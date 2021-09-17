# Kinoite website

This is source repo for the website available at <https://kinoite.fedoraproject.org/>.
The staging deployment is available at <https://stg.kinoite.fedoraproject.org/>.

## Setup

Install the extended version of Hugo from <https://gohugo.io/>.

## Preview

Run:

```
hugo serve
```

And point your browser to: <http://localhost:1313/>

## Build and deploy (staging & production branches)

We currently do not have support for Hugo built websites in Fedora. Thus we
temporarily manually build the website and push it to the stading and
production branches.

```bash
# Checkout staging branch
git worktree add ../fedoraloveskde.org-staging staging

# Build the final version
hugo --minify --config config.yaml,config_staging.yaml

# Copy the result
rsync --archive --human-readable --delete-after --verbose public/ ../kinoite-site-staging/public/

# Commit & push the result
git -C ../fedoraloveskde.org-staging add public
git -C ../fedoraloveskde.org-staging commit "Update ($(date --utc --iso-8601=min))"
git -C ../fedoraloveskde.org-staging push
```

Once satisfied with the result, do the same (without the staging config) to push to production.

## Working on the website

This is using [hugo](https://gohugo.io/). `layouts/index.html` contains the
homepage, `i18n/en.yaml` contains the strings and `assets/sass/bulma.scss`
contains the style.
