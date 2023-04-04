PYTHONPATH=/net/software/rpxdock/rpxdock /net/software/rpxdock/env/bin/python /net/software/rpxdock/rpxdock/rpxdock/app/dock.py \
	--architecture AXLE_C3 \
	--inputs1 input/scaffolds/C3_plug017_chA.pdb \
	--inputs2 input/scaffolds/o421_z.pdb \
	--allowed_residues2 input/allowed_residues/o421_z.txt \
	--max_trim 400 \
	--cart_bounds -300 300 \
	--beam_size 100000 \
	--docking_method grid \
	--grid_resolution_cart_angstroms 0.25 \
	--grid_resolution_ori_degrees 0.25 \
	--iface_summary min \
	--flip_components 0 1 \
	--hscore_files ailv_h \
	--hscore_data_dir /net/software/rpxdock/hscore \
	--score_only_ss EH \
	--loglevel debug \
	--max_delta_h 99999 \
	--use_orig_coords \
	--trimmable_components "C" \
	--output_prefix output/AXLE_C3 \
	--dump_pdbs \
	--filter_config ./filters.yml \
	--overwrite_existing_results \
	--function sasa_priority \
	--weight_sasa 2500 --weight_ncontact 5 --weight_error 4


