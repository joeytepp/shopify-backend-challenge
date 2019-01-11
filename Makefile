bootstrap: ## Set up environment
	bundle install
	rails db:create
	rails db:migrate

.PHONY: shop
