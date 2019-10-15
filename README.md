# alleleFrequencyApp

This repository contains code for a Shiny App to support certain allele frequency calculations for the assessment & interpretation of rare genetic variants.  

A manuscript describing our approach to allele frequency assessment is available on [biorxiv](http://biorxiv.org/content/early/2016/09/02/073114).   
You can see the app in action [here](https://www.cardiodb.org/allelefrequencyapp/).

## Local Deployment

A Dockerfile is included for local deployment. After cloning the respository the following commands will run a shiny server instance in single app mode exposing port 3838 and writing logs to `/var/log/shiny-server`.

```bash
docker build --tag=allelefrequencyapp:latest .

docker run -d -p 3838:3838 -v /var/log/shiny-server:/var/log/shiny-server allelefrequencyapp:latest
```

=====

alleleFrequencyApp - a Shiny App for allele frequency calculations Copyright (C) 2016 James Ware

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA