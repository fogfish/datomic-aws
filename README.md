# Datomic on AWS

The project is the appliance to managed and deploy [Datomic](http://www.datomic.com) solutions in automated and immutable manner using state-of-the-art CI/CD solutions. 

## Key Features

Datomic **artifacts** and **license** management using best practice of AWS security.

It defines a microservice like approach on Datomic deployment and operation. The appliance provides a **Cloud Formation** templates to spawn required AWS resources and treats them as *backing services* from appliance perspective. 

It provides techniques to build docker **containers** using *public* CI/CD solution without disclosing a license to public domain.

Enables various deployment schemas using docker **compose**, AWS **Cloud Formation** and many other.

The diagram below highlights the design of the appliance and its collaboration with delivery pipelines.

![Datomic on AWS](https://docs.google.com/drawings/d/1QW3PLuls9GTBMJlz5ov0NcGvRsJNVDX1D8N1Aw2-N0Y/pub?w=897&h=572)

**Components**

* `01` Cloud Formation template to spawns AWS resources, which are required for appliance management.
* `02` Cloud Formation template to spans AWS resources, which are required for operation of Datomic components and its peers.    
* `03` The definition of docker container that executes Datomic transactor.
* `04` An enterprise private repository to store container artifacts.
* `05` An instance of the appliance deployed to AWS Account.

**Operations**

* `10` encrypt Datomic license using AWS KMS service. The encrypted license becomes safe to distribute over public sources.
* `11` provision Datomic artifacts to AWS S3 bucket so that authorized actors do have access to it.
* `12` assembly docker container using pre-signed url concept
* `13` provision the container to *enterprise* private repository
* `14` automate deployment procedure using various techniques
* `15` share *backing services* configurations  
* `16` bootstrap Datomic transactor process with the configuration and licensee files



## Getting started 

The project supplies Cloud Formation templates and scripts to orchestrate Datomic provisioning into your AWS account. 

Use the latest version of appliance from the master `branch`. The build and deployment processes requires [AWS command-line utilities](https://aws.amazon.com/cli/). All development, including new features and bug fixes, take place on the `master` branch using forking and pull requests as described in these contribution guidelines.

Install directions with AWS-related details are [here](doc/install.md).

### Running appliance

You can run Datomic appliance locally once your AWS account is [configured](doc/install.md). Please ensure that your have a valid AWS credentials / tokens before running the appliance.

The first run of the appliance requires a license, run the following command to obtain license. 
```
make license
``` 

The following commands builds a Docker container and spawns Datomic and DynamoDB mock services at your Docker environment.
```
make docker
make run
```
You need to tune `/etc/hosts` of you host environment
```
sudo echo -e "127.0.0.1\tdocker" | tee -a /etc/hosts
```

Datomic is available for your peers at  `datomic:ddb-local://127.0.0.1:8000/datomic/yourdb`
Use [groovy shell](http://docs.datomic.com/groovysh.html) to evaluate your appliance. 
```
make dev
./datomic-pro-*/bin/groovysh
```

## Next Steps

* Learn the installation guidelines to AWS 
* Continue with Datomic peer development



## Contributing/Bugs

The orchestration scripts are MIT licensed and accepts contributions via GitHub pull requests:

* Fork the repository on GitHub
* Read the README.md for build instructions

### commit message

The commit message helps us to write a good release note, speed-up review process. The message should address two question what changed and why. The project follows the template defined by chapter [Contributing to a Project](http://git-scm.com/book/ch5-2.html) of Git book.

>
> Short (50 chars or less) summary of changes
>
> More detailed explanatory text, if necessary. Wrap it to about 72 characters or so. In some contexts, the first line is treated as the subject of an email and the rest of the text as the body. The blank line separating the summary from the body is critical (unless you omit the body entirely); tools like rebase can get confused if you run the two together.
> 
> Further paragraphs come after blank lines.
> 
> Bullet points are okay, too
> 
> Typically a hyphen or asterisk is used for the bullet, preceded by a single space, with blank lines in between, but conventions vary here
>

### bugs
If you experience any issues, please let us know via [GitHub issues](https://github.com/zalando-incubator/datomic-aws/issue). We appreciate detailed and accurate reports that help us to identity and replicate the issue.

* **Specify** the configuration of your environment. Include which operating system you use and the versions of runtime environments. 

* **Attach** logs, screenshots and exceptions, in possible.

* **Reveal** the steps you took to reproduce the problem.

### Contacts

* issues: [here](https://github.com/zalando-incubator/datomic-aws/issues) 

## License 

The MIT License (MIT)

Copyright (c) 2016 Zalando SE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
