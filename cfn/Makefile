#!/usr/bin/make -f

.PHONY: check-dependencies init test build create stage update
SHELL=/bin/bash -o pipefail
CONFIG=k3s-stack.config.yaml #Should be passed as an envVar
TEMPLATE=k3s-stack.template.yaml #Should be passed as an envVar
CHANGESET=k3s-stack-change.yaml  #Should be optimzed
ARTIFACT = .build/$(CONFIG)

CONFIGDIR = $(shell dirname $(CONFIG))

export AWS_PAGER =
export AWS_DEFAULT_OUTPUT = json

CLI = aws cloudformation

-include *.makefile

STACKNAME = $(shell yq -e '.StackName' $(CONFIG))
CAPABILITIES = $(shell yq -e '.Capabilities' $(CONFIG))

check-dependency = $(if $(shell command -v $(1)),,$(error Make sure $(1) is installed))

check-dependencies:
	@$(call check-dependency,aws)
	@$(call check-dependency,yq)
	@$(call check-dependency,shasum)

run-hook = $(MAKE) -n -f $(CONFIGDIR)/Makefile $(1) > /dev/null 2>&1; if [ "$$?" -eq "2" ]; then true; else echo "running $(1) hook" && ARTIFACT=$(ARTIFACT) $(MAKE) -f $(CONFIGDIR)/Makefile $(1); fi

init: check-dependencies
	@$(call run-hook,pre-init)
ifndef CONFIG
	$(error CONFIG needs to be set to a file or directory)
endif
	@$(call run-hook,post-init)

test-inline = yq -r '.TemplateBody' $(ARTIFACT) > $(ARTIFACT).template && $(CLI) validate-template --template-body file://$(ARTIFACT).template > /dev/null

test-url = yq -r '.TemplateURL' $(ARTIFACT) | xargs $(CLI) validate-template --template-url > /dev/null

outputs =	$(CLI) describe-stacks --stack-name $(STACKNAME) --query 'Stacks[].Outputs[]' --output table

build: init clean
	@$(call run-hook,pre-test)
	@$(call run-hook,post-test)
	@$(call run-hook,pre-build)
	@mkdir -p .build/$(CONFIG)
	@cp $(CONFIG) $(ARTIFACT)
	@$(call run-hook,post-build)

create: build
	@echo "$(STACKNAME)"
	@echo "$(TEMPLATE)"
	@echo "$(CAPABILITIES)"
	@$(call run-hook,pre-create)
	@$(CLI) create-stack --stack-name $(STACKNAME) --template-body file://$(TEMPLATE) --capabilities $(CAPABILITIES)
	@$(CLI) wait stack-create-complete --stack-name $(STACKNAME)
	@$(call run-hook,post-create)
	@$(call run-hook,post-create-or-update)
	@$(call outputs)

change: diff
	@$(call run-hook,pre-stage)
	@$(CLI) delete-change-set --stack-name $(STACKNAME) --change-set-name $(CHANGESET)
	@$(CLI) create-change-set --cli-input-json file://$(ARTIFACT) --change-set-name $(CHANGESET) --change-set-type UPDATE --output text --query 'Id'
	@$(CLI) wait change-set-create-complete --change-set-name $(CHANGESET) --stack-name $(STACKNAME)
	@$(CLI) describe-change-set --stack-name $(STACKNAME) --change-set-name $(CHANGESET) --output table --query "Changes[].{Action: ResourceChange.Action, LogicalId: ResourceChange.LogicalResourceId, Type: ResourceChange.ResourceType, Replacement: ResourceChange.Replacement, ResourceParameterStatic: join(', ', ResourceChange.Details[?Evaluation=='Static'].Target.Name), ResourceParameterDynamic: join(', ', ResourceChange.Details[?Evaluation=='Dynamic'].Target.Name)}"
	@$(call run-hook,post-stage)

update: init
	@$(call run-hook,pre-update)
	@$(CLI) execute-change-set --stack-name $(STACKNAME) --change-set-name $(CHANGESET)
	@$(CLI) wait stack-update-complete --stack-name  $(STACKNAME)
	@$(call run-hook,post-update)
	@$(call run-hook,post-create-or-update)
	@$(call outputs)

delete:
	@$(call run-hook,pre-delete)
	@$(CLI) delete-stack --stack-name $(STACKNAME)
	@$(CLI) wait stack-delete-complete --stack-name $(STACKNAME)
	@$(call run-hook,post-delete)


clean:
	@$(call run-hook,pre-clean)
	@rm -rf .build/$(CONFIG)
	@$(call run-hook,post-clean)
