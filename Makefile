test:
	isort pmml_ui
	black pmml_ui
	flake8 pmml_ui

clean:
	rm -r dist/

docker-build:
	docker build --platform=linux/amd64 -t pmml-ui:${VERSION} .
	docker tag pmml-ui:${VERSION} torarg/pmml-ui:${VERSION}
	docker tag pmml-ui:${VERSION} torarg/pmml-ui:latest

docker-publish:
	docker push torarg/pmml-ui:${VERSION}
	docker push torarg/pmml-ui:latest

python-build:
	poetry build

build: python-build docker-build

release-branch:
	git checkout -b release/${VERSION}
	poetry version ${VERSION}
	sed "s/torarg\/pmml-ui:.*/torarg\/pmml-ui:${VERSION}/g" kubernetes/deployment.yml > kubernetes/deployment.yml.new
	sed "s/pmml_ui-.*/pmml_ui-${VERSION}-py3-none-any.whl/g" Dockerfile > Dockerfile.new
	mv Dockerfile.new Dockerfile
	mv kubernetes/deployment.yml.new kubernetes/deployment.yml
	git commit -a -m "bump version for release ${VERSION}."
	git tag -a ${VERSION} -m "Release ${VERSION}"

merge-release:
	git checkout main
	git merge ${VERSION} --ff-only
	git checkout develop
	git merge ${VERSION} --no-ff -m 'Merge release ${VERSION} into develop.'

pypi-publish:
	poetry publish

git-publish:
	git checkout main
	git push --tags
	git push
	git checkout develop
	git push
	git branch -d release/${VERSION}

publish: pypi-publish docker-publish git-publish

release: release-branch build merge-release publish
