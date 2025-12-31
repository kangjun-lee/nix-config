#include "../sketchybar.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const char *command = "/opt/homebrew/bin/SwitchAudioSource -t output -c";

int main(int argc, char **argv) {
  float update_freq;
  if (argc < 3 || (sscanf(argv[2], "%f", &update_freq) != 1)) {
    printf("Usage: %s \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    exit(1);
  }

  char *event_name = argv[1];
  alarm(0);

  // Setup the event in sketchybar
  char event_message[512];
  snprintf(event_message, 512, "--add event '%s'", event_name);
  sketchybar(event_message);

  char trigger_message[512];
  char last_output[256] = {0};

  for (;;) {
    FILE *fp = popen(command, "r");
    if (fp == NULL) {
      usleep(update_freq * 1000000);
      continue;
    }

    char output[256] = {0};
    fgets(output, sizeof(output), fp);
    pclose(fp);

    // Remove trailing newline
    output[strcspn(output, "\r\n")] = 0;

    if (strlen(output) > 0 && strcmp(last_output, output) != 0) {
      strcpy(last_output, output);
      snprintf(trigger_message, 512, "--trigger '%s' device='%s'", event_name, output);
      sketchybar(trigger_message);
    }

    usleep(update_freq * 1000000);
  }
  return 0;
}
