PKG=WordPress
NS=au.org.nectar.qriscloud
TARGET=$(NS).$(PKG)
TEST=$(NS).test.$(PKG)
ZIP_EXCLUDE=-x \*/.\*.swp
.PHONY: $(TARGET).zip

all: $(TARGET).zip upload

build: $(TARGET).zip

clean:
	rm -rf $(TARGET).zip $(TEST).zip $(TEST)

test:
	@echo "Building package using test namespace..."; \
	rm -rf $(TEST).zip $(TEST); \
	cp -r $(TARGET) $(TEST); \
	sed -i 's/\($(NS)[.]\)/\1test./' $(TEST)/manifest.yaml $(TEST)/UI/*; \
	sed -i 's/^\(Name: .*\)$$/\1 Test/' $(TEST)/manifest.yaml; \
	sed -i 's/^\([ ]*=: $(NS)\)$$/\1.test/' $(TEST)/Classes/*.yaml; \
	cd $(TEST); zip ../$(TEST).zip -r * $(ZIP_EXCLUDE); cd ..; \
	murano package-import -c "Web" --package-version 1.0 --exists-action u $(TEST).zip

upload: $(TARGET).zip
	murano package-import -c "Web" --package-version 1.0 --exists-action u $(TARGET).zip

public:
	@echo "Searching for $(TARGET) package ID..."
	@package_id=$$(murano package-list --fqn $(TARGET) | grep $(TARGET) | awk '{print $$2}'); \
	echo "Found ID: $$package_id"; \
	murano package-update --is-public true $$package_id

$(TARGET).zip:
	rm -f $@; cd $(TARGET); zip ../$@ -r * $(ZIP_EXCLUDE); cd ..
