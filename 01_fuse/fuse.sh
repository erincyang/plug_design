OMP_NUM_THREADS=1 PYTHONPATH=/net/software/worms/worms /net/software/worms/env/bin/python -m worms @worms_plug.flags \
	--bbconn _C  C3_C   \
	         N_  Monomer \
	--dbfiles json/plug.json \
	--output_prefix output/ \
	>> output/log