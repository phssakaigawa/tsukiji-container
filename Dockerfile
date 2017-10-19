#centos7のイメージを取得
FROM centos:centos7

#Dockerfile作成者
MAINTAINER Pumpkin Heads Co.,Ltd. Shoichiro Sakaigawa sakaigawa@pumpkinheds.jp

#タイムゾーンの設定
RUN /bin/cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#yumによる必要パッケージのインストール
RUN yum -y install httpd unzip git

# Vulnerability Advisor : Fix PASS_MAX_DAYS, PASS_MIN_DAYS and PASS_MIN_LEN, common-password
RUN mv -f /etc/login.defs /etc/login.defs.orig
RUN sed 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs.orig > /etc/login.defs
RUN grep -q '^PASS_MIN_DAYS' /etc/login.defs && sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs || echo 'PASS_MIN_DAYS 1\n' >> /etc/login.defs
RUN grep -q '^PASS_MIN_LEN' /etc/login.defs && sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN 8/' /etc/login.defs || echo 'PASS_MIN_LEN 9\n' >> /etc/login.defs
RUN grep -q '^password.*required' /etc/pam.d/common-password && sed -i 's/^password.*required.*/password    required            pam_permit.so minlen=9/' /etc/pam.d/common-password || echo 'password    required            pam_permit.so minlen=9' >> /etc/pam.d/common-password



#yumリポジトリの追加
RUN yum -y localinstall http://ftp.iij.ad.jp/pub/linux/fedora/epel/epel-release-latest-7.noarch.rpm
RUN yum -y localinstall http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#yumによるphp7.0インストール
RUN yum install -y --enablerepo=remi --enablerepo=remi-php70 php php-common php-mbstring php-gd php-xml php-xmlrpc php-devel php-cli php-pdo php-mysql php-odbc php-pear php-mcrypt php-pecl-apc

#tmpディレクトリに移動
WORKDIR /tmp/

ADD app /tmp/app

#ディレクトリのリネーム
RUN mv app/* /var/www/html

#ディレクトリの権限変更
RUN chown -R apache:apache /var/www/html/

#httpd.confの変更
#RUN sed -i -e 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/eccube/html"#g' -e 's#<Directory "/var/www/html">#<Directory /var/www/html/eccube/html">#g' -e 's#AllowOverride None#AllowOverride All#g' /etc/httpd/conf/httpd.conf
RUN sed -i -e 's#AllowOverride None#AllowOverride All#g' /etc/httpd/conf/httpd.conf

#公開ポート
EXPOSE 80

#httpdの実行
CMD ["httpd", "-D", "FOREGROUND"]
