use_transforms="${1}"
input="${2}"
rpx_pickle_path="${3}"

#parse components
in_name=`echo ${input##*/} |cut -d'.' -f1`
split1=`echo ${in_name} |awk -F'__' '{print $1}'`
split2=`echo ${in_name} |awk -F'__' '{print $2}'`
split3=`echo ${in_name} |awk -F'__' '{print $3}'`
#split4=`echo ${in_name} |awk -F'__' '{print $3}'`
imodel=`echo ${in_name} |awk -F'_' '{print $3}'`

sym=`echo ${split1} |cut -d'_' -f1`
arche=`echo ${sym} |cut -c1`
axis1=`echo ${sym} |cut -c2`
axis2=`echo ${sym} |cut -c3`
axis3=`echo ${sym} |cut -c4`
dock=`echo ${split1} |cut -d'_' -f2-`
comp1=`echo ${split2} |cut -d'_' -f2-` #need this because of pre-trimming bbs
#comp1=`echo ${comp1_trim} |rev |cut -d'_' -f2- |rev`
comp2=`echo ${split3} |cut -d'_' -f2-` #need this because of pre-trimming bbs
#comp2=`echo ${comp2_trim} |rev |cut -d'_' -f2- |rev`
#comp3=`echo ${split4} |cut -d'_' -f2-`
reverse="F"

file_input="input/scaffolds/${in_name}.pdb"
echo $file_input
use_transforms="no_transforms"

#make folders
echo "making output folders"
echo "fusion_output/${sym}/${comp1}/${comp2}/${dock}"
mkdir -p fusion_output/${sym}/${comp1}/${comp2}/${dock}
outpath="fusion_output/${sym}/${comp1}/${comp2}/${dock}/"

#symmmetry
if [[ ${arche} == "C" ]]; then
	#echo "cyclic symmetry detected"
	symfile="symdef/${arche}/${sym}_Z.sym"
	symdof1="JS1"
fi

#parse jct_res
design_resis=`grep 'Modified positions:' ${file_input} |cut -d':' -f2 |tr -d ' '`
jct_res=`grep 'Junction residues:' ${file_input} |cut -d':' -f2 |tr -d ' '`
	jct_res1=`echo ${jct_res} |cut -d',' -f1`
	jct_res2=`echo ${jct_res} |cut -d',' -f2`
end_res=`grep 'ATOM' ${file_input} |tail -1 |cut -c 24-26 |tr -d " "`
	if [[ "${jct_res1}" == "${jct_res2}" ]]; then jct_res2=$(( ${end_res}-1 )); fi #if single junction, don't need junction 2
asu_chains=2
echo ${jct_res1}; echo ${jct_res2}; echo ${end_res}; echo ${asu_chains}

#parse asu chains
count=0
CHAINS=(A B C D E F G)
while [[ ${count} -lt ${asu_chains} ]]; do
	grep "ATOM" input/scaffolds/${in_name}.pdb |grep -E "^.{21}${CHAINS[${count}]}" >> input/scaffolds/${in_name}.tmp.pdb
	count=$(( ${count} + 1 ))
done

if [[ ! -e ${outpath}/score.sc ]]; then
	/software/rosetta/latest/bin/rosetta_scripts -database /software/rosetta/latest/main/database/ \
		-out::file::pdb_comments \
		-beta \
		-parser:protocol xml/junction_resfile_design.xml \
		-s input/scaffolds/${in_name}.pdb \
		-nstruct 1 \
		-parser:script_vars symdef="${symfile}" symdof1="${symdof1}" symdof2="${symdof2}" resnum="${design_resis}" jct_res1="${jct_res1}" jct_res2="${jct_res2}" end_res="${end_res}" outpath="${outpath}" in_name="${in_name}"\
		-overwrite 1 \
		-unmute all \
		-out:suffix "" \
		-out::path::all ${outpath} > ${outpath}/${in_name}.log
else
	echo "score.sc already exists!"
fi
