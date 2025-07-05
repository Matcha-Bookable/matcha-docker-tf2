# Matcha TF2 Dockerfile

This repository contains the source file of Matcha Bookable's Dockerfile and their build scripts, however the plugins and cfgs will remain hidden at this time.
The image gets built by Github's Action and pushes the image to Docker Hub which will be pulled by the on-demand instances. 

### Supported Registries
> I have originally planned to push to all major cloud computing providers' private registries. However, the costs incurred are currently not worth the compensation of simply faster pull time.

- [x] Docker Hub: Private Repository

#### Original Registries
- [x] <s>Google Cloud: Artifact Registry
- [x] Amazon Web Services: Elastic Container Registry
- [ ] Microsoft Azure: Container Registry
- [ ] Alibaba Cloud: Container Registry
</s>

## Additional Notes

> Personal Access Token is required to pull the server's plugins and cfgs. 

### Credits

- [spiretf/docker-tf2-server](https://codeberg.org/spire/docker-tf2-server)
- [spiretf/docker-comp-server](https://codeberg.org/spire/docker-comp-server)
- [jsza/docker-tempus-srcds](https://github.com/jsza/docker-tempus-srcds)
- [dalegaard/srctvplus](https://github.com/dalegaard/srctvplus)

### License
This project is licensed under the GNU GPLv3 License - see the [LICENSE](LICENSE) file for details.