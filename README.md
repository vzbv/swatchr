# swatchr

modified version of the original [swatchr](https://github.com/dstack/swatchr)

Allows superfast creation of a corporate design based on bootstrap 3.

Instant feedback through preview window, syntax highlighted variable editor.

Previews can be static html, or proxied websites using bootstrap.

## Usage

Copy the `active.json.example` files from both `public/content/previews` and `public/content/frameworks` to `active.json` and edit to your needs.

### Example `active.json` for custom bootstrap

```json
{
  "name": "Custom - Bootstrap 3",
  "location": "custom-bootstrap",
  "processor": "less",
  "default": true,
  "main": "less/my-bootstrap.less",
  "mainCompiled": "/path/to/compiled/css/bootstrap.min.css",
  "vars": "less/corporate-design.less",
  "varsReplaceTarget": "@import \"corporate-design.less\";"
}
```
Notice `mainCompiled` which refers to a path where the compiled minified css will reside. This is used to replace the compiled bootstrap version with a dynamic one in external previews (see below).

### Example `active.json` for external previews

```json
{
  "name": "Start",
  "url": "http://yourwebsite.com",
  "external": true,
  "default": false,
  "desc": "Frontpage of our Website"
}
```
When selecting the __Start__ preview, your browser will send a request to swatchr, which will in turn request the given url (`http://yourwebsite.com`) and replace the static `bootstrap.min.css` with a dynamic style tag to fill in  updated css.

## Under the hood

`config.js` acts as a file server for preview and frameworks (LESS files) and as a proxy for external requests.
