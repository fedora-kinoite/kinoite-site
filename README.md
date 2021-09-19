# Fedora Kinoite website

This is source repo for the website available at <https://kinoite.fedoraproject.org/>.
The staging deployment is available at <https://stg.kinoite.fedoraproject.org/>.

## Setup

Install the extended version of Hugo from <https://gohugo.io/>.

## Preview

Run:

```bash
hugo serve
```

And point your browser to: <http://localhost:1313/>

## Build and deploy (staging & production branches)

We currently do not have support for Hugo built websites in Fedora. Thus we
temporarily manually build the website and push it to the stading and
production branches.

All the commands needed to do so are stored in the `justfile` in the repo that
you can use with <https://github.com/casey/just>.

The details of each steps follow:

- Install hugo-i18n for translation support:

```bash
sudo dnf install python3-pip gettext
git clone https://invent.kde.org/websites/hugo-i18n.git
cd hugo-i18n
pip install -r requirements.txt
pip install .
```

- Checkout staging branch in a distinct folder as a git worktree:

```bash
git worktree add ../kinoite-site-staging staging
```

- Update the translations:

```bash
export PACKAGE="websites-kinoite-fedoraproject-org"
export FILENAME="kinoite-fedoraproject-org"
hugoi18n extract po/kinoite-fedoraproject-org.pot
hugoi18n compile po
hugoi18n generate
```

- Build the staging website:

```bash
hugo --minify --config config.yaml,config_staging.yaml
```

- Copy the result to the staging directory

```bash
rsync --archive --human-readable --delete-after --verbose public/ ../kinoite-site-staging/public/
```

- Commit & push the result

```bash
git -C ../kinoite-site-staging add public
git -C ../kinoite-site-staging commit "Update ($(date --utc --iso-8601=min))"
git -C ../kinoite-site-staging push
```

- Wait for <https://stg.kinoite.fedoraproject.org/> to be updated (happens every hour).

- Once satisfied with the result, repeat (without the staging config) to push
  to production:

```bash
git worktree add ../kinoite-site-production production
hugo --minify
rsync --archive --human-readable --delete-after --verbose public/ ../kinoite-site-production/public/
git -C ../kinoite-site-production add public
git -C ../kinoite-site-production commit "Update ($(date --utc --iso-8601=min))"
git -C ../kinoite-site-production push
```

## Working on the website

This is using [hugo](https://gohugo.io/). `layouts/index.html` contains the
homepage, `i18n/en.yaml` contains the strings and `assets/sass/bulma.scss`
contains the style.
