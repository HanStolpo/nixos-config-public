{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    httpConfig =
    ''
        ## Start client.lanlocal.blah ##
        server {
          listen       80;
          server_name  circuithub.test;

          ## send request back to apache1 ##
          location / {
            proxy_pass  http://127.0.0.1:8081;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
        ## Start api.lanlocal.blah ##
        server {
          listen       80;
          server_name  api.circuithub.test;

          ## send request back to apache1 ##
          location / {
            proxy_pass  http://127.0.0.1:8082;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
        ## Start projects.lanlocal.blah ##
        server {
          listen       80;
          server_name  projects.circuithub.test;

          ## send request back to apache1 ##
          location / {
            proxy_pass  http://127.0.0.1:8083;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
        ## Start reactor.lanlocal.blah ##
        server {
          listen       80;
          server_name  reactor.circuithub.test;

          ## send request back to apache1 ##
          location / {
            proxy_pass  http://localhost:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
    '';
  };
}
