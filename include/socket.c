#include "socket.h"
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

int create_socket(int port) {
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
  host_addr.sin_port = htons(port);
  host_addr.sin_addr.s_addr = htonl(INADDR_ANY);

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

  return sockfd;
}

int recieve_req(int sockfd, char *buffer, int size) {
  int bytes_read = read(sockfd, buffer, size);
  if (bytes_read < 0) {
    perror("couldn't READ\n");
    return 1;
  }

  return bytes_read;
}

int send_resp(int sockfd, char *resp) {
  int valwrite = write(sockfd, resp, strlen(resp));
  if (valwrite < 0) {
    perror("couldn't send Response\n");
    return 1;
  }
  printf("Response sent successfully!\n");

  return 0;
}

int run_server(int sockfd) {
  int newsockfd = accept(sockfd, NULL, NULL);
  if (newsockfd < 0) {
    perror("couldn't ACCEPT the socket!\n");
    return -1;
  }
  printf("ACCEPTED!\n");
  return newsockfd;
}

// int main() {
//   int sockfd = create_socket(8080);

//   for (;;) {
//     char resp[] = "Hello World!\n";
//     int newsockfd = run_server(sockfd);
//     if (newsockfd < 0)
//       continue; // accept failed, skip

//     send_resp(newsockfd, resp); // send on the accepted socket

//     close(newsockfd);
//   }

//   return 0;
// }
