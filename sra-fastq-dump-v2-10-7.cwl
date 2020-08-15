{
    "class": "CommandLineTool",
    "cwlVersion": "v1.0",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "id": "hendrick.san/covid19/sra-fastq-dump-v2-10-7/0",
    "baseCommand": [
        "mkdir $HOME/.ncbi && printf '/LIBS/GUID = \"%s\"\\n' `uuidgen` > $HOME/.ncbi/user-settings.mkfg && printf '/repository/user/main/public/root = \"/opt\"\\n' >> $HOME/.ncbi/user-settings.mkfg && fastq-dump"
    ],
    "inputs": [
        {
            "id": "sra_file",
            "type": "File[]?",
            "label": "SRA file",
            "doc": "SRA file to convert to FASTQ",
            "sbg:fileTypes": "SRA"
        },
        {
            "id": "sra_accession",
            "type": "string[]?",
            "label": "Accession (SRA accession)",
            "doc": "SRA accesion from which to download the data."
        },
        {
            "sbg:toolDefaultValue": "True",
            "id": "split_files",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--split-files",
                "shellQuote": false
            },
            "label": "Split files",
            "doc": "Write reads into separate files. Read number will be suffixed to the file name. NOTE! The `--split-3` option is recommended. In cases where not all spots have the same number of reads, this option will produce files that WILL CAUSE ERRORS in most programs which process split pair fastq files.",
            "default": false
        },
        {
            "id": "split_spots",
            "type": "boolean?",
            "inputBinding": {
                "position": 1,
                "prefix": "--split-spot",
                "shellQuote": false
            },
            "label": "Split spot",
            "doc": "Split spots into individual reads.",
            "default": null
        },
        {
            "id": "fasta",
            "type": "string?",
            "inputBinding": {
                "position": 2,
                "prefix": "--fasta",
                "shellQuote": false
            },
            "label": "FASTA only",
            "doc": "FASTA only, no qualities. Width can be \"default\" or \"0\" for no wrapping."
        },
        {
            "sbg:altPrefix": "-F",
            "id": "oringinal_seq_name",
            "type": "boolean?",
            "inputBinding": {
                "position": 4,
                "prefix": "--origfmt",
                "shellQuote": false
            },
            "label": "Original sequence name",
            "doc": "Defline contains only original sequence name."
        },
        {
            "sbg:altPrefix": "-C",
            "id": "dump_cskey",
            "type": "string?",
            "inputBinding": {
                "position": 5,
                "prefix": "--dumpcs",
                "shellQuote": false
            },
            "label": "Dump cskey",
            "doc": "Formats sequence using color space (default for SOLiD), \"cskey\" may be specified for translation or else specify \"dflt\" to use the default value"
        },
        {
            "sbg:altPrefix": "-B",
            "id": "dump_base",
            "type": "boolean?",
            "inputBinding": {
                "position": 6,
                "prefix": "--dumpbase",
                "shellQuote": false
            },
            "label": "Sequence formatting - base space",
            "doc": "Formats sequence using base space (default for other than SOLiD)."
        },
        {
            "sbg:altPrefix": "-Q",
            "id": "offset",
            "type": "int?",
            "inputBinding": {
                "position": 7,
                "prefix": "--offset",
                "shellQuote": false
            },
            "label": "Offset",
            "doc": "Offset to use for ASCII quality scores. Default is 33 (\"!\")."
        },
        {
            "sbg:altPrefix": "-N",
            "id": "min_spot_id",
            "type": "string?",
            "inputBinding": {
                "position": 8,
                "prefix": "--minSpotId",
                "shellQuote": false
            },
            "label": "Minimum sopt ID",
            "doc": "Minimum spot id to be dumped. Use with \"max_spot_id\" to dump a range."
        },
        {
            "sbg:altPrefix": "-X",
            "id": "max_spot_id",
            "type": "string?",
            "inputBinding": {
                "position": 9,
                "prefix": "--maxSpotId",
                "shellQuote": false
            },
            "label": "Maximum spot ID",
            "doc": "Maximum spot id to be dumped. Use with \"N\" to dump a range."
        },
        {
            "sbg:altPrefix": "-M",
            "id": "min_read_length",
            "type": "int?",
            "inputBinding": {
                "position": 10,
                "prefix": "--minReadLen",
                "shellQuote": false
            },
            "label": "Minimum read leangth",
            "doc": "Filter by sequence length (greater or equal to chosen value)."
        },
        {
            "id": "skip_techincal",
            "type": "boolean?",
            "inputBinding": {
                "position": 11,
                "prefix": "--skip-technical",
                "shellQuote": false
            },
            "label": "Skip technical",
            "doc": "Dump only biological reads."
        },
        {
            "id": "dump_aligned",
            "type": "boolean?",
            "inputBinding": {
                "position": 12,
                "prefix": "--aligned",
                "shellQuote": false
            },
            "label": "Dump aligned reads",
            "doc": "Dump only aligned sequences.",
            "default": null
        },
        {
            "id": "dump_unaligned",
            "type": "boolean?",
            "inputBinding": {
                "position": 13,
                "prefix": "--unaligned",
                "shellQuote": false
            },
            "label": "Dump unaligned",
            "doc": "Dump only unaligned sequences.",
            "default": null
        },
        {
            "id": "gzip_compress",
            "type": "boolean?",
            "inputBinding": {
                "position": 14,
                "prefix": "--gzip",
                "shellQuote": false
            },
            "label": "Gzip compress",
            "doc": "Compress output using gzip: deprecated, not recommended",
            "default": null
        },
        {
            "id": "bzip2_compress",
            "type": "boolean?",
            "inputBinding": {
                "position": 15,
                "prefix": "--bzip2",
                "shellQuote": false
            },
            "label": "bzip2 compress",
            "doc": "Compress output using bzip2: deprecated, not recommended",
            "default": null
        },
        {
            "sbg:altPrefix": "-A",
            "id": "replace_accession",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--accession",
                "shellQuote": false
            },
            "label": "Replace accession",
            "doc": "Replaces accession derived from <path> in filename(s) and deflines (only for single table dump)"
        },
        {
            "id": "table",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--table",
                "shellQuote": false
            },
            "label": "Table name",
            "doc": "Table name within cSRA object, default is \"SEQUENCE\"."
        },
        {
            "id": "spot_groups",
            "type": [
                "null",
                {
                    "type": "array",
                    "items": "string",
                    "inputBinding": {
                        "separate": true
                    }
                }
            ],
            "inputBinding": {
                "position": 0,
                "prefix": "--spot-groups",
                "itemSeparator": " ",
                "shellQuote": false
            },
            "label": "Spot groups",
            "doc": "Filter by SPOT_GROUP (member): name[,...]"
        },
        {
            "id": "clip",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--clip",
                "shellQuote": false
            },
            "label": "Clip adapter sequences",
            "doc": "Remove adapter sequences from reads"
        },
        {
            "sbg:altPrefix": "-R",
            "id": "read_filter",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--read-filter",
                "shellQuote": false
            },
            "label": "Split by READ_FILTER",
            "doc": "Split into files by READ_FILTER value [split], optionally filter by value:  [pass|reject|criteria|redacted]"
        },
        {
            "sbg:altPrefix": "-E",
            "id": "quality_filter",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--qual-filter",
                "shellQuote": false
            },
            "label": "Quality filter",
            "doc": "Filter used in early 1000 Genomes data: no sequences starting or ending with >= 10N"
        },
        {
            "id": "quality_filter1",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--qual-filter-1",
                "shellQuote": false
            },
            "label": "Quality filter 1",
            "doc": "Filter used in current 1000 Genomes data"
        },
        {
            "id": "aligned_region",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--aligned-region",
                "shellQuote": false
            },
            "label": "Aligned region",
            "doc": "Filter by position on genome. In format \"name[:from-to]\". Name can either by accession.version (ex: NC_000001.10) or file specific name (ex: \"chr1\" or \"1\". \"from\" and \"to\" are 1-based coordinates."
        },
        {
            "id": "matepair_distance",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--matepair_distance",
                "shellQuote": false
            },
            "label": "Matepair distance",
            "doc": "Filter by distance between matepairs. In format  \"from-to\" or use \"unknown\" to find matepairs split between the references. Use from-to to limit matepair distance on the same reference."
        },
        {
            "id": "split_3",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--split-e",
                "shellQuote": false
            },
            "label": "Split 3",
            "doc": "3-way splitting for mate-pairs. For each spot, if there are two biological reads satisfying filter conditions, the first is placed in the `*_1.fastq` file, and the second is placed in the `*_2.fastq` file. If there is only one biological read satisfying the filter conditions, it is placed in the `*.fastq` file.All other reads in the spot are ignored."
        },
        {
            "sbg:altPrefix": "-K",
            "id": "keep_empty_files",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--keep-empty-files",
                "shellQuote": false
            },
            "label": "Keep empty files",
            "doc": "Do not delete empty files"
        },
        {
            "id": "supress_qual_for_cskey",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--suppress-qual-for-cskey",
                "shellQuote": false
            },
            "label": "Suppress quality for cskey",
            "doc": "Suppress quality for cskey"
        },
        {
            "sbg:altPrefix": "-I",
            "id": "read_ids",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--readids",
                "shellQuote": false
            },
            "label": "Read IDs",
            "doc": "Append read id after spot id as 'accession.spot.readid' on defline"
        },
        {
            "id": "helicos",
            "type": "boolean?",
            "inputBinding": {
                "position": 0,
                "prefix": "--helicos",
                "shellQuote": false
            },
            "label": "Helicos",
            "doc": "Helicos style defline"
        },
        {
            "id": "defline_seq",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--defline-seq",
                "shellQuote": false
            },
            "label": "Defline format - sequence",
            "doc": "Defline format specification for sequence."
        },
        {
            "id": "defline_qual",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--defline-qual",
                "shellQuote": false
            },
            "label": "Defline format - qualities",
            "doc": "Defline format specification for quality. <fmt> is string of characters and/or variables. The variables can be one of: $ac - accession, $si spot id, $sn spot name, $sg spot group (barcode), $sl spot length in bases, $ri read number, $rn read name, $rl read length in bases. '[]' could be used for an optional output: if all vars in [] yield empty values whole group is not printed. Empty value is empty string or for numeric variables. Ex: @$sn[_$rn]/$ri '_$rn' is omitted if name is empty"
        },
        {
            "id": "ngc_file",
            "type": "File?",
            "inputBinding": {
                "position": 0,
                "prefix": "--ngc",
                "shellQuote": false
            },
            "label": "NGC file",
            "doc": "NGC file",
            "sbg:fileTypes": "NGC"
        },
        {
            "id": "premission_file",
            "type": "File?",
            "inputBinding": {
                "position": 0,
                "prefix": "--perm",
                "shellQuote": false
            },
            "label": "Permission file",
            "doc": "Permission file"
        },
        {
            "id": "location",
            "type": "string?",
            "inputBinding": {
                "position": 0,
                "prefix": "--location",
                "shellQuote": false
            },
            "label": "Location in the cloud",
            "doc": "Location in the cloud"
        },
        {
            "id": "cart_file",
            "type": "File?",
            "inputBinding": {
                "position": 0,
                "prefix": "--cart",
                "shellQuote": false
            },
            "label": "CART file",
            "doc": "CART file"
        },
        {
            "id": "option_file",
            "type": "File?",
            "inputBinding": {
                "position": 0,
                "prefix": "--option-file",
                "shellQuote": false
            },
            "label": "Option file",
            "doc": "Read more options and parameters from the file."
        }
    ],
    "outputs": [
        {
            "id": "out_reads",
            "doc": "Reads downloaded with SRA toolkit.",
            "label": "Out reads",
            "type": [
                "null",
                "File",
                {
                    "type": "array",
                    "items": "File"
                }
            ],
            "outputBinding": {
                "glob": "{*.fastq, *.gz, *.bz2}"
            },
            "sbg:fileTypes": "FASTQ, GZIP, BZ2"
        }
    ],
    "doc": "**SRA Toolkit** from NCBI is a collection of tools and libraries for using data in the INSDC Sequence Read Archives format (SRA). \n\n**NOTE: SRA toolkit requires an *interactive configuration* since version 2.10.1 [2]. Running this tool on the platform triggers the configuration *automattically*!  Please find more information in the *'Changes introduced by Seven Bridges'* section.**\n\nTool **SRA fastq-dump** converts SRA data into FASTQ format. With aligned data, NCBI uses Compression by Reference, which only stores the differences in base pairs between sequence data and the segment it aligns to. The process to restore original data, for example as FastQ, requires fast access to the reference sequences that the original data was aligned to. [1]\n\n*A list of all inputs and parameters with corresponding descriptions can be found at the bottom of this page.*\n\n###Common Use Cases\n\n- **SRA fastq-dump** accepts both SRA file and SRA accession as input. To dump from SRA file, choose your file with **SRA file** input port, and leave **SRA accession** to empty. If you wish to use SRA accession, leave the **SRA file** port empty, and type the accesion in **SRA accession** field. \n- Output could be FASTA (FASTQ with qualities omitted) by setting **FASTA** to True and optionally setting  **FASTA line width**. \n- Output cold also be GZIP/BZIP2 archived FASTQ/FASTA by setting **Gzip compress** or **bzip2 compress** to True.\n- To format sequence using color space set **dump CSkey** to True. Specify the cskey with **CSkey** parameter.\n\n\n###Changes introduced by Seven Bridges\n- In order to access even the public data, the tool needs to be configured. [2] The authors have provided the interactive solution to this problem, but since this solution is not perfect for environments such as Seven Bridges platform and many other, further solutions are being discussed [3][4][5]. The current solution on the platform entails that the blank configuration file containing just the UUID (universally unique identifier) is created inside a specific folder in the root directory. This approach is taken from the authors' [Dockerfile](https://github.com/ncbi/sra-tools/blob/master/build/docker/Dockerfile).\n\n### Performance Benchmarking\n\nThe speed and cost of the workflow depend on the size of the cDNA FASTQ files. Following table showcases the metrics for the task running on the c5.2xlarge on demand AWS instance. The price can be significantly reduced by using spot instances (set by default). Visit [The Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.\n\n| Assay type | Input                       | Paired-end | Number of bases | Output size | Duration | Price | Instance type |\n|------------|-----------------------------|------------|-----------------|-------------|----------|-------|---------------|\n| RNAseq     | single SRA accession        | no         | 900M            | 4GB         | 3 min    | $0.02 | c4.2xlarge    |\n| RNAseq     | multiple SRA accessions (5) | no         | 5 x 400M        | 5 x 1.5GB   | 8 min    | $0.05 | c4.2xlarge    |\n| WES        | single SRA accession        | yes        | 2 x 6.18G       | 2 x 7.5GB   | 16 min   | $0.10 | c4.2xlarge    |\n| WGS        | single SRA accession        | yes        | 2 x 114.3G      | 2 x 137.3GB | 4h 4 min | $1.62 | c4.2xlarge    |\n\n### References\n\n[1] [NCBI SRA Toolkit documentation](https://ncbi.github.io/sra-tools/)\n\n[2] [Instructions for SRA toolkit installation and configuration](https://github.com/ncbi/sra-tools/wiki/03.-Quick-Toolkit-Configuration)\n\n[3] [SRA Github issue #282](https://github.com/ncbi/sra-tools/issues/282)\n\n[4] [SRA Github issue #291](https://github.com/ncbi/sra-tools/issues/291)\n\n[5] [SRA Github issue #310](https://github.com/ncbi/sra-tools/issues/310)",
    "label": "SRA fastq-dump",
    "arguments": [
        {
            "position": 100,
            "prefix": "",
            "shellQuote": false,
            "valueFrom": "${\n    // Returns SRA file or SRA accesion if availabe \n    \n    var cmd = \"\"\n    \n    if(inputs.sra_file){\n        for (var i = 0; i < inputs.sra_file.length; i++){\n            cmd += inputs.sra_file[i].path + \" \"\n        }\n    }\n    if(inputs.sra_accession){\n        for (var i = 0; i < inputs.sra_accession.length; i++){\n            cmd += inputs.sra_accession[i]  + \" \"\n        }\n    } \n    return cmd\n}"
        }
    ],
    "requirements": [
        {
            "class": "ShellCommandRequirement"
        },
        {
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/milica_aleksic/sra-toolkit-v2-10-7:1"
        },
        {
            "class": "InlineJavascriptRequirement"
        }
    ],
    "sbg:projectName": "COVID19",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1592663116,
            "sbg:revisionNotes": "Copy of YCGL_PI/sra/sra-fastq-dump-v2-10-7/1"
        }
    ],
    "sbg:image_url": null,
    "sbg:toolkit": "SRA Toolkit",
    "sbg:toolAuthor": "NCBI",
    "sbg:links": [
        {
            "id": "https://ncbi.github.io/sra-tools/",
            "label": "Documentation"
        },
        {
            "id": "https://github.com/ncbi/ncbi-vdb",
            "label": "SourceCode"
        },
        {
            "id": "https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software",
            "label": "Download"
        },
        {
            "id": "https://www.ncbi.nlm.nih.gov/books/NBK242621/",
            "label": "Publication"
        },
        {
            "id": "https://ncbi.github.io/sra-tools/",
            "label": "Homepage"
        }
    ],
    "sbg:appVersion": [
        "v1.0"
    ],
    "sbg:id": "hendrick.san/covid19/sra-fastq-dump-v2-10-7/0",
    "sbg:revision": 0,
    "sbg:revisionNotes": "Copy of YCGL_PI/sra/sra-fastq-dump-v2-10-7/1",
    "sbg:modifiedOn": 1592663116,
    "sbg:modifiedBy": "hendrick.san",
    "sbg:createdOn": 1592663116,
    "sbg:createdBy": "hendrick.san",
    "sbg:project": "hendrick.san/covid19",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "hendrick.san"
    ],
    "sbg:latestRevision": 0,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a3f5f16e12a4339b7f1db473ab54795a99b0d8a28ad306c72ec41c64b1ab378a5",
    "sbg:copyOf": "YCGL_PI/sra/sra-fastq-dump-v2-10-7/1"
}