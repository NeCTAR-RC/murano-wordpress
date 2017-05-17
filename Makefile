TARGET=au.org.nectar.qriscloud.WordPress
.PHONY: $(TARGET).zip

all: $(TARGET).zip upload

build: $(TARGET).zip

clean:
	rm -rf $(TARGET).zip

upload: $(TARGET).zip
	murano package-import -c "Web" --package-version 1.0 --exists-action u $(TARGET).zip

public:
	@echo "Searching for $(TARGET) package ID..."
	@package_id=$$(murano package-list --fqn $(TARGET) | grep $(TARGET) | awk '{print $$2}'); \
	echo "Found ID: $$package_id"; \
	murano package-update --is-public true $$package_id

$(TARGET).zip:
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
