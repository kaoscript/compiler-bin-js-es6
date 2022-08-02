tag:
	git tag v0.10.0 $( git rev-parse HEAD ) --force
	git push origin --tags --force
