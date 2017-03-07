---
layout: post
title:  "Ubuntu 下安装 Ruby 和 Jekyll"
date:   2016-11-10 14:06:21 +0800
categories: jekyll install
---

# Jekyll官网： http://jekyllrb.com/

{% highlight bash %}
# Ubuntu系统下安装ruby/rails必要的库和编译环境
sudo apt-get update
sudo apt-get install -y build-essential openssl curl libcurl3-dev libreadline6 libreadline6-dev git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev libsqlite3-dev

# rbenv环境安装
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
type rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# ruby环境安装，首先列出可安装的版本，然后选择后进行下载编译
rbenv install -l
rbenv install 2.3.1

# 设置当前使用的ruby版本并将gem的源改为ruby-china镜像
rbenv global 2.3.1
rbenv rehash

＃ruby-china镜像使用说明　https://gems.ruby-china.org/
# 请尽可能用比较新的 RubyGems 版本，建议 2.6.x 以上。
gem update --system # 这里请翻墙一下
gem -v
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem sources -l  # 确保只有 gems.ruby-china.org

# 安装 jekyll
gem install jekyll bundler jekyll-docs

# 创建 blogsite 项目
jekyll new blogsite

# 启动项目
cd blogsite
bundle exec jekyll serve -H 0.0.0.0 -P 1109

# 查看 Jekyll 文档
jekyll docs

{% endhighlight %}


