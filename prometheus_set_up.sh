# prometheus.yml 파일 필요
wget https://github.com/prometheus/prometheus/releases/download/v3.0.0-rc.1/prometheus-3.0.0-rc.1.linux-amd64.tar.gz &&
  tar xvfz prometheus-3.0.0-rc.1.linux-amd64.tar.gz &&
  mv prometheus-3.0.0-rc.1.linux-amd64 prometheus &&
  mv prometheus.yml ./prometheus/prometheus.yml &&
  ./prometheus/prometheus \
    --config.file=prometheus/prometheus.yml \
    --storage.tsdb.retention.time=90d \
    --storage.tsdb.retention.size=5GB
