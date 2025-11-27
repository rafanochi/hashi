#include "netinet/in.h"
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
  char buffer[BUFFER_SIZE];
  char resp[] = "HTTP/1.0 200 OK\r\n"
                "Server: webserver-c\r\n"
                "Content-type: text/html\r\n\r\n"
                "<html>hello, world</html>\r\n";

  // create the socket
  int sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd == -1) {
    perror("couldn't create a socket!\n");
    return 1;
  }
  printf("socket created successfully\n");

  struct sockaddr_in host_addr;
  int host_addrlen = sizeof(host_addr);

  host_addr.sin_family = AF_INET;
  host_addr.sin_port = htons(PORT);
  host_addr.sin_addr.s_addr = htonl(INADDR_ANY);

  struct sockaddr_in client_addr;
  int client_addrlen = sizeof(client_addr);

  if (bind(sockfd, (struct sockaddr *)&host_addr, host_addrlen) != 0) {
    perror("couldn't bind the socket!\n");
    return 1;
  }
  printf("socket BINDED successfully\n");

  if (listen(sockfd, SOMAXCONN) != 0) {
    perror("couldn't bind the socket!\n");
    return 1;
  }
  printf("LISTENING...\n");

  for (;;) {
    int newsockfd = accept(sockfd, (struct sockaddr *)&host_addr,
                           (socklen_t *)&host_addrlen);
    if (newsockfd < 0) {
      perror("couldn't ACCEPT the socket!\n");
      continue;
    }
    printf("ACCEPTED!\n");

    int sockname = getsockname(newsockfd, (struct sockaddr *)&client_addr,
                               (socklen_t *)&client_addrlen);
    if (sockname < 0) {
      perror("couldn't get sockname");
      continue;
    }

    char method[BUFFER_SIZE], uri[BUFFER_SIZE], version[BUFFER_SIZE];
    sscanf(buffer, "%s %s %s", method, uri, version);
    printf("\nClient ADDRESS =  [%s:%u] %s %s %s\n\n",
           inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port), method,
           version, uri);

    int valread = read(newsockfd, buffer, BUFFER_SIZE);
    if (valread < 0) {
      perror("couldn't READ\n");
      continue;
    }

    printf("%s", buffer);

    int valwrite = write(newsockfd, resp, strlen(resp));
    if (valwrite < 0) {
      perror("couldn't WRITE\n");
      continue;
    }
    printf("Response sent successfully!\n");

    close(newsockfd);
  }

  return 0;
}
