# Mirror Index JSON Schema (v1)

This document specifies the JSON schema produced by `sbin/mirror-site` when mirroring a website. The index is designed to be:

- Human-inspectable
- Programmatically stable across versions
- Extensible without breaking existing consumers

Current `schema_version`: 1

## Top-level structure

```jsonc
{
  "meta": { ... },
  "items": [ ... ],
  "urls": { ... },
  "graph": { ... },
  "skipped_urls": [ ... ],
  "errors": [ ... ]
}
```

All timestamps are ISO-8601 in UTC (e.g., `2025-09-23T19:56:21.500508+00:00`).

---

## meta

Describes the run context and arguments used to generate this index.

Fields:
- `base_url` (string; required): Normalized root URL used as the crawl start.
- `generated_at` (string; required): Timestamp of index generation.
- `target_root` (string; required): Absolute path to the mirror folder on disk.
- `items_count` (integer; required): Number of entries in `items`.
- `tool` (string; required): Tool name; currently `mirror-site`.
- `tool_version` (string; required): Tool version string; currently `"1"`.
- `schema_version` (integer; required): Schema version; currently `1`.
- `run_id` (string; optional): UUID for the run (present during crawl-time writes).
- `args` (object; optional): Arguments used for this run.
  - `link_depth` (integer)
  - `same_domain` (boolean)
  - `delay_seconds` (number)
  - `timeout` (integer)
  - `user_agent` (string)
  - `post_process` (boolean)
  - `re_download_all` (boolean)
  - `concurrency` (integer)

---

## items

Represents the mirrored filesystem view with file- and directory-level metadata. Sorted by `(type, path)` when written.

Each element is an object with fields:

Common fields:
- `path` (string; required): POSIX-style relative path from `target_root`. For the root directory, this is `"."`.
- `type` (string; required): `"file"` or `"dir"`.
- `size` (integer; required): Size in bytes (for files). For directories, aggregate size of contained files.
- `name` (string; required): Basename of the entry.
- `ext` (string; required): File extension (for files), empty for directories.
- `kind` (string; required): `"page"`, `"asset"`, or `"dir"`.
- `section` (string; required): Heuristic top-level path segment (e.g., `"lab"`, `"notat"`). For root: `"."`.

File-specific fields (present when `type == "file"`):
- `mtime` (string; required): Last modification time on disk.
- `mime` (string; required): MIME type guess; `application/octet-stream` if unknown.
- `sha256` (string; optional): Local content hash; omitted if `--no-hash`.
- `source_url` (string; optional): Original URL that produced this local file.
- `final_url` (string; optional): Final URL after redirects.
- `http_status` (integer; optional): HTTP response status code for the last fetch.
- `downloaded_at` (string; optional): Timestamp of last successful fetch.
- `original_etag` (string; optional): HTTP `ETag` header value.
- `original_last_modified` (string; optional): Parsed `Last-Modified` header in ISO-8601 if parseable, otherwise the header string.
- `original_content_type` (string; optional): HTTP `Content-Type` header.
- `original_content_length` (integer|string; optional): HTTP `Content-Length` header (as integer if parseable).
- `target_abs_path` (string; required): Absolute path to this file on disk.
- `target_root` (string; required): Absolute path to the mirror root.
- `page_meta` (object; optional): Extracted HTML metadata for pages.
  - `title` (string; optional)
  - `meta_description` (string; optional)
  - `canonical_url` (string; optional)
  - `robots` (string; optional)
  - `hreflang` (array of objects; optional): `{ "lang": string, "href": string }`
  - `h1` (array of strings; optional)
  - `h2` (array of strings; optional)
  - `word_count` (integer; optional)

Directory-specific fields (present when `type == "dir"`):
- `items` (integer; required): Number of contained items (recursive).

---

## urls

A URL-centric map keyed by absolute URL. This captures network/provenance details and local mapping.

Value object fields:
- `url` (string; required): The key URL, repeated for convenience.
- `final_url` (string; optional): Final URL after redirects.
- `http_status` (integer; optional): Last HTTP status.
- `headers` (object; optional): Original response headers as a lower-cased dictionary.
- `downloaded_at` (string; optional): Timestamp of last successful fetch.
- `local_path` (string; required): Relative local path the URL mapped to.
- `kind` (string; required): `"page"`, `"asset"`, or `"unknown"`.
- `referers` (array of strings; optional): Absolute URLs linking to this URL.
- `depth` (integer; optional): First-seen depth from the starting page.

---

## graph

Represents the site link structure captured during crawl.

Fields:
- `out_edges` (object; required): Map of `source_url -> [dest_urls...]` discovered from `href` and `src` attributes.
- `in_edges` (object; required): Reverse map of `dest_url -> [source_urls...]` derived from `out_edges`.

Note: Currently link types (href vs src) are not distinguished. Future versions may add typed edges.

---

## skipped_urls

Records URLs that were encountered but not fetched. Each element is an object:
- `ts` (string; required): Timestamp when the skip was recorded.
- `url` (string; required): Skipped URL.
- `reason` (string; required): One of `non-http(s) scheme`, `file-scheme`, `out-of-domain`, `robots-disallow`, `filter-exclude`.
- `from` (string; required): Absolute URL of the page where the link was found.

---

## errors

Records crawl errors. Each element is an object:
- `ts` (string; required): Timestamp when the error was recorded.
- `url` (string; required): URL attempted.
- `stage` (string; required): A short label such as `fetch` or `asset-download`.
- `error` (string; required): Error message.

---

## Example (abridged)

```json
{
  "meta": {
    "base_url": "https://example.com/",
    "generated_at": "2025-09-23T19:56:21.500508+00:00",
    "target_root": "/abs/path/mirror",
    "items_count": 123,
    "tool": "mirror_site.py",
    "tool_version": "1",
    "schema_version": 1,
    "args": {
      "link_depth": 2,
      "same_domain": true,
      "delay_seconds": 0.5,
      "timeout": 60,
      "user_agent": "Mozilla/5.0 ...",
      "post_process": true,
      "re_download_all": false,
      "concurrency": 4
    }
  },
  "items": [
    {
      "path": ".",
      "type": "dir",
      "size": 1024,
      "items": 5,
      "kind": "dir",
      "name": ".",
      "ext": "",
      "section": "."
    },
    {
      "path": "index.html",
      "type": "file",
      "size": 4096,
      "mtime": "2025-09-23T19:55:00+00:00",
      "mime": "text/html",
      "sha256": "...",
      "source_url": "https://example.com/",
      "final_url": "https://example.com/",
      "http_status": 200,
      "downloaded_at": "2025-09-23T19:55:01+00:00",
      "original_etag": "\"abc123\"",
      "original_last_modified": "2025-09-23T19:00:00+00:00",
      "original_content_type": "text/html",
      "original_content_length": 4096,
      "target_abs_path": "/abs/path/mirror/index.html",
      "target_root": "/abs/path/mirror",
      "name": "index.html",
      "ext": ".html",
      "kind": "page",
      "section": ".",
      "page_meta": { "title": "Home", "word_count": 250 }
    }
  ],
  "urls": {
    "https://example.com/": {
      "url": "https://example.com/",
      "final_url": "https://example.com/",
      "http_status": 200,
      "headers": { "content-type": "text/html; charset=utf-8" },
      "downloaded_at": "2025-09-23T19:55:01+00:00",
      "local_path": "index.html",
      "kind": "page",
      "referers": [],
      "depth": 0
    }
  },
  "graph": {
    "out_edges": { "https://example.com/": ["https://example.com/about/"] },
    "in_edges": { "https://example.com/about/": ["https://example.com/"] }
  },
  "skipped_urls": [],
  "errors": []
}
```

---

## Versioning Policy

- Backward-compatible additions (e.g., adding fields) do not change `schema_version`.
- Backward-incompatible changes (e.g., renaming or removing fields, changing meaning) must increment `schema_version` and update this document.
- Consumers should:
  - Check `schema_version` and gracefully ignore unknown fields.
  - Treat optional fields as missing when not present.

## Future Extensions (non-breaking)

- Typed link edges (href vs src), per-link attributes
- Redirect chains (`redirect_chain`)
- Additional page metadata (OpenGraph/Twitter cards)
- Conditional GET result markers (304 vs 200)
- Content-level deduplication references
