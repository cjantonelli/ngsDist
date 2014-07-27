
#include "read_data.hpp"
#include "gen_func.hpp"

// Reads both called genotypes (1 field per site and indiv), genotype lkls or genotype post probs (3 fields per site and indiv)
double*** read_geno(char *in_geno, bool in_bin, bool in_probs, uint64_t n_ind, uint64_t n_sites){
  uint64_t n_fields;
  // Depending on input we will have either 1 or 3 genot
  uint64_t n_geno = (in_probs ? N_GENO : 1);
  double *t;
  double *ptr;
  char *buf = init_ptr(BUFF_LEN, (const char*) '\0');

  // Allocate memory
  double ***geno = init_ptr(n_ind, n_sites+1, N_GENO, -INF);
  
  // Open GENO file
  gzFile in_geno_fh = gzopen(in_geno, in_bin ? "rb" : "r");
  if(in_geno_fh == NULL)
    error(__FUNCTION__, "cannot open GENO file!");

  for(uint64_t s = 1; s <= n_sites; s++){
    if(in_bin){
      for(uint64_t i = 0; i < n_ind; i++)
	if( gzread(in_geno_fh, geno[i][s], N_GENO * sizeof(double)) != N_GENO * sizeof(double) )
	  error(__FUNCTION__, "cannot read GENO file!");
    }
    else{
      if( gzgets(in_geno_fh, buf, BUFF_LEN) == NULL)
	error(__FUNCTION__, "cannot read GENO file!");
      // Remove trailing newline
      chomp(buf);
      // Check if empty
      if(strlen(buf) == 0)
	continue;
      // Parse input line into array
      n_fields = split(buf, (const char*) " \t", &t);

      // Check if header and skip
      if(!n_fields){
	s--;
	continue;
      }

      if(n_fields < n_ind * n_geno)
	error(__FUNCTION__, "wrong GENO file format!");
      
      // Use last "n_ind * n_geno" columns
      ptr = t + (n_fields - n_ind * n_geno);
      
      if(in_probs)
	for(uint64_t i = 0; i < n_ind; i++)
          for(uint64_t g = 0; g < N_GENO; g++)
            geno[i][s][g] = ptr[i*N_GENO+g];
      else
	for(uint64_t i = 0; i < n_ind; i++){
          int g = (int) ptr[i];
          if(g < 0 || g > 2)
            error(__FUNCTION__, "wrong GENO format!");
          geno[i][s][g] = log(1);
        }

      delete [] t;
    }
  }
  
  gzclose(in_geno_fh);
  delete [] buf;
  return geno;
}







double* read_pos(char *in_pos, uint64_t n_ind, uint64_t n_sites){
  uint64_t n_fields;
  char **t;
  char *buf = init_ptr(BUFF_LEN, (const char*) '\0');

  char *prev_chr = init_ptr(BUFF_LEN, (const char*) '\0');
  uint64_t prev_pos = 0;

  // Allocate memory
  double *pos_dist = init_ptr(n_sites+1, INFINITY);

  // Open file
  gzFile in_pos_fh = gzopen(in_pos, "r");
  if(in_pos_fh == NULL)
    error(__FUNCTION__, "cannot open POS file!");

  for(uint64_t s = 1; s <= n_sites; s++){
    if( gzgets(in_pos_fh, buf, BUFF_LEN) == NULL)
      error(__FUNCTION__, "cannot read POS file!");
    // Remove trailing newline
    chomp(buf);
    // Check if empty
    if(strlen(buf) == 0)
      continue;
    // Parse input line into array
    n_fields = split(buf, (const char*) " \t", &t);

    // Check if header and skip
    if(!n_fields){
      s--;
      continue;
    }

    if(n_fields < 2)
      error(__FUNCTION__, "wrong POS file format!");

    if(strcmp(prev_chr, t[0]) == 0 || strlen(prev_chr) == 0)
      pos_dist[s] = strtod(t[1], NULL) - prev_pos;
    else {
      pos_dist[s] = INFINITY;
      strcpy(prev_chr, t[0]);
    }
    prev_pos = strtoul(t[1], NULL, 0);

    delete [] t;
  }

  gzclose(in_pos_fh);
  delete [] buf;
  delete [] prev_chr;

  return pos_dist;
}