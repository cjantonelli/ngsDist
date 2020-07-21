SIM_DATA=../../ngsSim/examples
ANGSD=../../angsd


##### Clean up
rm -f testA_*


N_IND=24
N_SITES=10000


##### Genotypes
cat $SIM_DATA/testA.geno | perl -s -p -e 's/0 0/0/g; s/(\w) \1/2/g; s/\w \w/1/g; $n=s/2/2/g; tr/02/20/ if($n>$n_ind/2)' -- -n_ind=$N_IND | awk '{print "chrSIM\t"NR"\t"$0}' | gzip -cfn --best > testA_T.geno.gz
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_T.geno.gz --n_ind $N_IND --n_sites $N_SITES --labels testA.labels                                     --out testA_T.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_T.geno.gz --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5                      --out testA_TB.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_T.geno.gz --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10 --out testA_TB-10.dist

##### Genotypes' likelihood and posterior probabilities
# Genotype Likelhoods (BEAGLE)
$ANGSD/angsd -glf $SIM_DATA/testA.glf.gz -fai $SIM_DATA/testAF.ANC.fas.fai -nInd $N_IND -doMajorMinor 1 -doGlf 2 -out testA_2
zcat testA_2.beagle.gz | cut -f 1-3 | tr "_" "\t" | tail -n +2 > testA.pos
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_2.beagle.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --pos testA.pos                                                                                  --out testA_2.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_2.beagle.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --pos testA.pos --n_boot_rep 5                                                                   --out testA_2B.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_2.beagle.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --pos testA.pos --n_boot_rep 5 --boot_block_size 10                                              --out testA_2B-10.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_2.beagle.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --pos testA.pos --n_boot_rep 5 --boot_block_size 10 --call_geno                                  --out testA_2B-10CG.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_2.beagle.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --pos testA.pos --n_boot_rep 5 --boot_block_size 10 --call_geno --N_thresh 0.3 --call_thresh 0.9 --out testA_2B-10CGf.dist

# Binary, normal-scale
$ANGSD/angsd -glf $SIM_DATA/testA.glf.gz -fai $SIM_DATA/testAF.ANC.fas.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out testA_32
gunzip -f testA_32.geno.gz
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_32.geno --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels                                                                                  --out testA_32.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_32.geno --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5                                                                   --out testA_32B.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_32.geno --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10                                              --out testA_32B-10.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_32.geno --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10 --call_geno                                  --out testA_32B-10CG.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_32.geno --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10 --call_geno --N_thresh 0.3 --call_thresh 0.9 --out testA_32B-10CGf.dist

# Text, normal scale
$ANGSD/angsd -glf $SIM_DATA/testA.glf.gz -fai $SIM_DATA/testAF.ANC.fas.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 8 -out testA_8
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_8.geno.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels                                                                                  --out testA_8.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_8.geno.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5                                                                   --out testA_8B.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_8.geno.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10                                              --out testA_8B-10.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_8.geno.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10 --call_geno                                  --out testA_8B-10CG.dist
../ngsDist --n_threads 10 --seed 12345 --verbose 1 --geno testA_8.geno.gz --probs --n_ind $N_IND --n_sites $N_SITES --labels testA.labels --n_boot_rep 5 --boot_block_size 10 --call_geno --N_thresh 0.3 --call_thresh 0.9 --out testA_8B-10CGf.dist


##### Check MD5
rm -f *.arg
TMP=`mktemp --suffix .ngsDist`
md5sum testA_* | fgrep -v '.gz' | sort -k 2,2 > $TMP
if diff $TMP test.md5 > /dev/null
then
    echo "ngsDist: All tests OK!"
else
    echo "ngsDist: test(s) failed!"
fi
