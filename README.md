# ytnobody/docker-nginx-bigquery

Logs of nginx on Docker container that will be forwarded to Google BigQuery.

## Prepare

### Create a table on bigquery

First, you have to create "schema.json" file. This is a spec for creating a table. Contents as following.

    [
      { "name": "time",    "type": "timestamp" },
      { "name": "remote",  "type": "string"  },
      { "name": "host",    "type": "string"  },
      { "name": "user",    "type": "string"  },
      { "name": "method",  "type": "string"  },
      { "name": "path",    "type": "string"  },
      { "name": "code",    "type": "integer" },
      { "name": "size",    "type": "integer" },
      { "name": "referer", "type": "string" },
      { "name": "agent",   "type": "string" }
    ]

Next, create a table on bigquery through bq utility.

    $ bq mk -t your-project-id:your-dataset.access_log schema.json

### Create a private key of Google Computing Engine

It requires OAuth Client private-key for authentication. You have to create OAuth Client ID from [Google Developers Console](https://console.developers.google.com/).

Please see [Setting up OAuth 2.0](https://developers.google.com/console/help/new/#generatingoauth2) to more datail information.

### Create a private git repository that contains configuration files

You have to put following files into private git repository.

    ./
    ├── bigquery-key.p12 (OAuth client private key for GCE / fixed filename)
    ├── bigquery.rc (Specify environment values / fixed filename)
    └── nginx
        └── *.conf (virtual host configuration)

And, example of bigquery.rc is following.

    export BIGQUERY_EMAIL=xxxxxxxxxx@developer.gserviceaccount.com
    export BIGQUERY_PROJECT=your-projectid-123
    export BIGQUERY_DATASET=your-dataset
    export BIGQUERY_TABLE=access_log

Then, push these to remote repository.

## Docker run

You have to specify the URL of your private git repository as "CONF\_REPO" when docker run.

Example.

    $ docker run -e CONF_REPO=https://username:password@gitdomain/path/to/YourPrivRepo.git -p 80:80 -d ytnobody/docker-nginx-bigquery

## Exposed port

* 80/tcp

