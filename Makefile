tag:
	@git add .
	
	@echo "Enter the commit message:"
	@read commit_message
	@git commit -m "$commit_message"
	
	@git tag v0.11.0 $( git rev-parse HEAD ) --force
	@git push origin --tags --force
