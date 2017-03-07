---
layout: post
title:  "Spark快速安装与部署运行"
date:   2017-02-18 09:21:21 +0800
categories: spark ml
---


### 1. Stand-alone-Mode Deployment


* [Spark Standalone Mode](http://spark.apache.org/docs/latest/spark-standalone.html)

```zsh

# 下载最新版本Spark 2.1.0-bin-hadoop2.7 [released (Dec 28, 2016)]
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz

# 下载最新稳定版 2.0.2-bin-hadoop2.7 [released (Nov 14, 2016)] <On>
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz



# 启动 Master 节点并绑定 MasterUI 的端口为 8090
./sbin/start-master.sh --webui-port 8090

# 启动 Slave 节点，需要指定 master 的地址, 默认为 spark://<HOSTNAME>:7077
# ./sbin/start-slave.sh <master-spark-URL>
./sbin/start-slave.sh spark://host29:7077

# 链接 spark-shell
# ./bin/spark-shell --master spark://IP:PORT
./bin/spark-shell --master spark://host29:7077


```


### 2. Deployment Hadoop Cluster [HDFS]

* [Hadoop: Setting up a Single Node Cluster](http://hadoop.apache.org/docs/r2.7.3/hadoop-project-dist/hadoop-common/SingleCluster.html)

```zsh

wget http://apache.fayea.com/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz


# etc/hadoop/hadoop-env.sh

export JAVA_HOME="/home/zhubolong/local/jdk1.8.0_102"

# etc/hadoop/core-site.xml

<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://ict24:8020</value>
    </property>
</configuration>

# etc/hadoop/hdfs-site.xml

<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>


$ bin/hdfs namenode -format
$ sbin/start-dfs.sh

```

### 3. Spark Submit

* init.py
```python
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("spark://host29:7077").setAppName("My SparkApp Python")
sc = SparkContext(conf = conf)
```

* App.java
```java
package com.ict.golaxy;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;

public class App 
{
    public static void main( String[] args )
    {
                // Create a Java Spark Context
                SparkConf conf = new SparkConf().setMaster("spark://host29:7077").setAppName("My SparkApp Java");
                JavaSparkContext sc = new JavaSparkContext(conf);
    }
}
```

* InitDemo.scala
```scala
package com.ict.golaxy;

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._


object InitDemo {

    def main(args: Array[String]): Unit = {

        val conf = new SparkConf().setMaster("spark://host29:7077").setAppName("My SparkApp Scala")
        val sc = new SparkContext(conf)
    }
}
```


```zsh

# python
spark-submit init.py


# scala
sbt clean compile package
spark-submit --class com.ict.golaxy.InitDemo ./target/scala-2.11/learning-spark-mini-example_2.11-0.0.1.jar


# java

mvn archetype:generate -DgroupId=com.ict.golaxy -DartifactId=sparkdemo -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

mvn clean compile package

spark-submit --class com.ict.golaxy.App ./target/sparkdemo-1.0-SNAPSHOT.jar

```
