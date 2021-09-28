site := "kinoite-site"
short_site := "kin"
po_name := "kinoite-fedoraproject-org"
export PACKAGE := "websites-kinoite-fedoraproject-org"
export FILENAME := "kinoite-fedoraproject-org"
date := `date --utc --iso-8601=min`

all: serve

serve:
	hugo serve

clean:
	rm -rf ./public

lang:
	rm -rf ./locale && mkdir locale
	hugoi18n extract po/{{po_name}}.pot
	hugoi18n compile po
	hugoi18n generate

staging: clean lang
	hugo --minify --config config.yaml,config_staging.yaml
	rsync --archive --human-readable --delete-after --verbose public/ ../{{site}}-staging/public/

production: clean lang
	hugo --minify
	rsync --archive --human-readable --delete-after --verbose public/ ../{{site}}-production/public/

commit-stg: staging
	git -C ../{{site}}-staging add public
	git -C ../{{site}}-staging commit -m "Update ({{date}})"

amend-stg: staging
	git -C ../{{site}}-staging add public
	git -C ../{{site}}-staging commit --amend -m "Update ({{date}})"

commit-prod: production
	git -C ../{{site}}-production add public
	git -C ../{{site}}-production commit -m "Update ({{date}})"

amend-prod: production
	git -C ../{{site}}-production add public
	git -C ../{{site}}-production commit --amend -m "Update ({{date}})"

push-stg:
	git -C ../{{site}}-staging push

push-prod:
	git -C ../{{site}}-production push

final: staging production

final-commit: commit-stg commit-prod

final-amend: amend-stg amend-prod

final-push: push-stg push-prod

log-stg:
	git -C ../{{site}}-staging status
	git -C ../{{site}}-staging log --pretty=oneline --max-count=10

log-prod:
	git -C ../{{site}}-production status
	git -C ../{{site}}-production log --pretty=oneline --max-count=10
