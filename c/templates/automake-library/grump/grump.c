# include "grump.h"

void grump_some(  )
{
  printf("Oh, bother!...\n\n");
}

void grump_a_lot_more(  )
{
  int i, index;
  char *grumps[5] = { "Aargh!", "Be gone!", "Sigh...",
    "Not again!", "Go away!" };

  for (i = 0; i < 5; i++)
  {
    index = (5.0 * rand(  ) / (RAND_MAX + 1.0));
    printf("%s\n", grumps[index]);
  }
}
