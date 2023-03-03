test:
	isort pmml_ui
	black pmml_ui
	flake8 pmml_ui

clean:
	rm -r dist/

docker:
	docker build --platform=linux/amd64 -t pmml-ui:${VERSION} .
	docker tag pmml-ui:${VERSION} torarg/pmml-ui:${VERSION}
	docker tag pmml-ui:${VERSION} torarg/pmml-ui:latest
	docker push torarg/pmml-ui:${VERSION}
	docker push torarg/pmml-ui:latest

create-release-branch:
	git checkout -b release/${VERSION}

bump-version:
	git checkout -b release/${VERSION}
	poetry version ${VERSION}
	sed "s/torarg\/pmml-ui:.*/torarg\/pmml-ui:${VERSION}/g" kubernetes/deployment.yml > kubernetes/deployment.yml.new
	sed "s/pmml-ui==.*/pmml-ui==${VERSION}/g" Dockerfile > Dockerfile.new
	mv Dockerfile.new Dockerfile
	mv kubernetes/deployment.yml.new kubernetes/deployment.yml
	git commit -a -m "bump version for release ${VERSION}."

publish:
	poetry publish --build
	git tag -a ${VERSION} -m "Release ${VERSION}"
	git push --tags
	git checkout main
	git merge release/${VERSION} --no-ff -m 'Merge release ${VERSION} into main.'
	git push

release: bump-version publish docker
