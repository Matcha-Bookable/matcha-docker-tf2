# Matcha TF2 Dockerfile

This repository contains the source file of Matcha Bookable's Dockerfile and their build scripts, however the plugins and cfgs will remain hidden at this time.
The image gets built by Github's Action and pushes the image to the major cloud provider's container registries.

### Supported Registries
- [x] Google Cloud: Artifact Registry
- [x] Amazon Web Services: Elastic Container Registry
- [ ] Microsoft Azure: Container Registry
- [ ] Alibaba Cloud: Container Registry

## Additional Notes

> Personal Access Token is required to pull the server's plugins and cfgs. 

### Credits

- [spiretf/docker-tf2-server](https://codeberg.org/spire/docker-tf2-server)
- [spiretf/docker-comp-server](https://codeberg.org/spire/docker-comp-server)
- [jsza/docker-tempus-srcds](https://github.com/jsza/docker-tempus-srcds)
- [dalegaard/srctvplus](https://github.com/dalegaard/srctvplus)

### License
This project is licensed under the GNU GPLv3 License - see the [LICENSE](LICENSE) file for details.