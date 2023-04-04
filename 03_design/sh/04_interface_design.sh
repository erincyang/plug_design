#2020-02-17
input="${1}"

#define run settings
exe_path="/software/rosetta/latest/bin/rosetta_scripts"

#fragment store db
fragment_store="indexed_structure_store:fragment_store /home/bcov/sc/scaffold_comparison/data/ss_grouped_vall_all.h5"
#dump asu? (true/false)
dump_asu="false"

#parse components
in_name=`echo ${input##*/} |cut -d'.' -f1`
split1=`echo ${in_name} |awk -F'__' '{print $1}'`
split2=`echo ${in_name} |awk -F'__' '{print $2}'`
split3=`echo ${in_name} |awk -F'__' '{print $3}'`
split4=`echo ${in_name} |awk -F'__' '{print $3}'`

sym=`echo ${split1} |cut -d'_' -f1`
arche=`echo ${sym} |cut -c1`
axis1=`echo ${sym} |cut -c2`
axis2=`echo ${sym} |cut -c3`
axis3=`echo ${sym} |cut -c4`
dock=`echo ${split1} |cut -d'_' -f2-`

#figure out trim or no trim
comp1=`echo ${split2} | cut -d'_' -f2-`
comp2=`echo ${split3} |cut -d'_' -f2`

reverse="F"

#check number of components
num_comp_real=1
num_comp=2

#parse dofs
a1="0"
a2="0"
r1="0"
r2="0"

#use input from fusion design output
mkdir -p input/scaffolds
inpath="input/scaffolds/"
dock_path="fusion_output/${sym}/${comp1}/${comp2}/${dock}"
if [[ -e ${dock_path}/${in_name}.pdb.gz ]]; then gunzip ${dock_path}/${in_name}.pdb.gz; fi
sed '/TER/q' ${dock_path}/${in_name}.pdb |grep "ATOM" |grep -E "^.{21}A" > input/scaffolds/${sym}_${dock}_${comp1}_${comp2}.tmp.pdb
if [[ "${num_comp}" == "2" ]] || [[ "${num_comp}" == "3" ]]; then
    sed '/TER/{x;//{x;q};x;h}' ${dock_path}/${in_name}.pdb |grep "ATOM" |grep -E "^.{21}B" >> input/scaffolds/${sym}_${dock}_${comp1}_${comp2}.tmp.pdb
fi
file_input="input/scaffolds/${sym}_${dock}_${comp1}_${comp2}.pdb"
use_transforms='no_transforms'

#make folders
mkdir -p interface_output/${sym}/${comp1}/${comp2}/${dock}
outpath="interface_output/${sym}/${comp1}/${comp2}/${dock}/"
	
#symmmetry
if [[ ${num_comp} == "2" ]]; then
	if [[ ${sym} == "C3" ]]; then symdof1="JRCA";   symdof2="JRCB";   
		nsub_bb="${axis1}";   symfile=symdef/${sym}_${axis1}.sym
	else echo "undefined sym ?????"; exit ; fi
fi

#check reverse
flip_axes="0,0"
if [[ "${reverse}" == 'R' ]]; then
	flip_axes="y,0"
	if [[ "${comp1_dummy}" == "dummy" ]]; then
		flip_axes="0"
	fi
fi

#run Rosetta
if [[ ! -e ${outpath}/score.sc ]]; then
	${exe_path} \
        -${fragment_store} \
        -dunbrack_prob_buried 0.8 -dunbrack_prob_nonburied 0.8 -dunbrack_prob_buried_semi 0.8 -dunbrack_prob_nonburied_semi 0.8 \
		-out::file::pdb_comments \
		-parser:protocol xml/interface_design.xml \
		-s      ${file_input} \
		-native ${file_input} \
		-beta \
		-nstruct 1 \
		-parser:script_vars sym="${symfile}" a1="${a1}" a2="${a2}" r1="${r1}" r2="${r2}" nsub_bb="${nsub_bb}" flip_axes="${flip_axes}" symdof1="${symdof1}" symdof2="${symdof2}" outpath="${outpath}" use_transforms="${use_transforms}" comp="${num_comp}comp" comp1_chew="${comp1_chew}" comp2_chew="${comp2_chew}" \
		-overwrite 1 \
		-unmute all \
		-out:chtimestamp 1 \
		-out:suffix "" \
		-out:level 300 \
		-out::path::all ${outpath}/ \
        -output_only_asymmetric_unit ${dump_asu} \
        -failed_job_exception False \
        -mute core.select.residue_selector.SecondaryStructureSelector \
		> ${outpath}/${sym}_${dock}_${comp1}_${comp2}.log
else
	echo "${outpath}/score.sc exists!"
fi


#delete input to save space
rm ${file_input}
