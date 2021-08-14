{
    "class": "Workflow",
    "cwlVersion": "sbg:draft-2",
    "id": "hendrick.san/covid19/rapid-identification-workflow/8",
    "label": "Rapid Identification Workflow",
    "description": "**Metagenomics WGS analysis -  Centrifuge 1.0.3** is a workflow for analyzing metagenomic samples against a custom reference, allowing researchers to assign reads in their samples to a likely species of origin and quantify each species’ abundance in the sample. Alignment and classification are performed by **Centrifuge classifier** [1]. You can use our default, publicly available references which can be found on the Seven Bridges platform under Public Reference Files, or build your own reference from NCBI using the **Reference Index Creation** workflow or **Centrifuge Build** tool.  Publicly available references are *bacteria_archaea.tar* (which consists of all the complete genomes for bacteria and archaea), *bacteria_archaea_viruses.tar* (which consists of all the complete genomes for bacteria, viruses, and archaea) and *nt.tar.gz* (that consists of all genomes available in NCBI's nt database). Alignment and classification are then performed by **Centrifuge Classifier**. The output is provided as circular trees and bar charts (**HTML report for all samples**), as well as text files that contain both summary metrics per species (**Centrifuge report**) and the classification of individual reads (**Classification results**). There is also **Krona chart report**, an HTML file with circular Krona [2] interactive graphs.\n\nOutput files containing estimated read counts (**Counts table**) and taxonomy information (**Taxonomy table**) are meant to be used in **Microbiome Differential Abundance Analysis**, which analyzes differential abundance of species between samples using **metagenomeSeq** R package [3]. This analysis could be copied from [Data Cruncher Interactive Analyses](https://igor.sbgenomics.com/u/sevenbridges/data-cruncher-interactive-analyses/analysis/cruncher) public project and executed within Jupyter Notebook using our [Data Cruncher](https://docs.sevenbridges.com/docs/run-an-analysis-using-data-cruncher).\n\nThe workflow takes two inputs:\n\n- **Metagenomic samples**, a list of FASTQ or FASTQ.GZ files, with their paired-end and sample ID metadata set. This workflow will produce a report for each sample provided, and it is more efficient to run this with all your samples than to create a batch task (see **Common Issuses** below);\n- A **Centrifuge Reference Index** in TAR format; for large indexes the TAR.GZ format can be used, however, in that case we suggest the user manually set the required memory for Centrifuge classifier job by changing the value for the **Memory per job** parameter (see **Common Issuses** below).\n\nA list of all inputs and parameters with corresponding descriptions can be found at the end of the page.\n\n### Common Use Cases\n\nThis workflow is designed to analyze several metagenomics samples in parallel (scattered by **Sample_ID**). \nThe user should provide FASTQ files for a desired number of samples and one Centrifuge Reference Index file (in TAR or TAR.GZ format). If the samples are host-associated, it is presumed that the reads are already cleaned from the host sequences (as done in [Human Microbiome Project](https://hmpdacc.org/hmp/doc/HumanSequenceRemoval_SOP.pdf)).\n\nA user can upload their own index, or they can use the **Reference Index Creation workflow** from the SBG platform for creating one by downloading reference sequences from NCBI directly. Providing an index with a smaller number of organisms (for example, in cases when the user is just interested in detecting one particular species) can result in mis-calculated abundance of organisms within the sample.\n\nAfter the workflow has successfully completed, it outputs Ccentrifuge results and reports, Kraken-like reports, alignment metrics, circular graphs and bar charts for each sample, and one final HTML report for the whole analysis.\n\n\n### Changes Introduced by Seven Bridges\n\n* **Centrifuge Classifier** option `--met-file` does not work properly, so the basic alignment (classification) metrics are calculated with an in-house script called **SBG Centrifuge-Alignment Metrics**. It outputs the total number of reads, the number of classified and unclassified reads, and those classified to exactly one category.\n\n\n### Common Issues and Important Notes\n\n* The Metadata field **Sample_ID** must be set for all files found on the **Metagenomic samples** input node. This info is important for pairing files and scattering the whole pipeline, as well as for creating reports.\n* The maximum number of samples that can be analyzed with this workflow is limited by the available disk space. Based on our experience, the workflow uses approximately  2.8 times more disk space than the size of all the input files (**Metagenomic samples** and **Centrifuge Reference Index** ). By default, the storage of 1 TB is available for this workflow, which means that maximum overall size of input files should not exceed 350 GB.\n* If the index is in TAR.GZ format, the memory for Centrifuge Classifier should be set manually by changing the default value for the **Memory per job** parameter (in MB). Based on our experience, it would be enough to use twice as much memory as the size of the index file and with an additional 4GB overhead. For example, if the size of the index file is 8GB, the user should use 8 x 2 + 4 = 20GB, that is 20 x 1024 = 20480MB.\n\n### Performance Benchmarking\n\n**Centrifuge Classifier** needs enough memory (based on our experience 4GB more than the size of the index files is suggested) in order to work properly. If the index is in TAR format, the tool will automatically allocate the required memory size. However, if the index is in TAR.GZ, the compression ratio is not always the same, so we suggest in that case the user manually set the required amount of memory necessary for the Centrifuge classifier job by changing the default value for the **Memory per job** parameter. This way, using instances with more memory than needed or task failures would be avoided.\n\nBased on our experience, we chose to manually set the **r4.4xlarge** instance for running the Metagenomics WGS analysis workflow, because it has the most appropriate ratio of CPU cores to RAM for Centrifuge Classifier and a good cost-to-value ratio. The instance could be changed by the user if necessary. To find out how to change the instance, please refer to the [documentation](https://docs.sevenbridges.com/docs/set-computation-instances#section-set-the-instance-type-for-a-workflow). \n\nIn the following table you can find estimates of **Metagenomics WGS analysis - Centrifuge 1.0.3** running time and cost.  *Cost can be significantly reduced by using **spot instances**. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Experiment type | Input size | Duration | Cost | Instance (AWS)\n| --- | --- | --- | --- | --- |\n|Bacteria index, one throat sample|Index 13 GB, reads SRS013948 throat sample 2 x 3.8 GB| 26m| $ 0.59 | r4.4xlarge|\n|p_h_v.tar index, 17 samples (34 fastq files)|Index 6.9 GB, FASTQ files ranging from 130 MB up to 3.8 GB| 1h 1m| $ 1.25 | r4.4xlarge|\n|Large index file - nt.tar.gz, one throat sample|Index 63.9 GB zipped, reads SRS013948 throat sample 2 x 3.8 GB | 1h 32m | $ 3.4 | r4.8xlarge|\n\n\n### API Python Implementation\nThe workflow's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for the corresponding platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).\n\n```python\nfrom sevenbridges import Api\n\nauthentication_token, api_endpoint = \"enter_your_token\", \"enter_api_endpoint\"\napi = Api(token=authentication_token, url=api_endpoint)\n# Get project_id/workflow_id from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/workflow\nproject_id, workflow_id = \"your_username/project\", \"your_username/project/workflow\"\n# Get file names from files in your project. Names of the files in this example are fictious.\ninputs = {\n    \"centrifuge_index_archive \": api.files.query(project=project_id, names=['bacteria.tar'])[0],\n    \"fastq_list\": list(api.files.query(project=project_id, names=['sample1.pe_1.fastq', \n                                                             'sample1.pe_2.fastq']))\n}\ntask = api.tasks.create(name='Metagenomics WGS Analysis - API Example', project=project_id, app=workflow_id, inputs=inputs, run=True)\n```\nInstructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).\n\nAdditionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).\n\n### References\n\n[1] [Centrifuge home page - manual](http://www.ccb.jhu.edu/software/centrifuge/manual.shtml)\n[2] [Krona hierarchical graphs](https://www.google.com/url?q=https://github.com/marbl/Krona/wiki&sa=D&source=hangouts&ust=1527254314760000&usg=AFQjCNGqbHlwzXvtqwi96JJfVSltx2fXrw)  \n[3] [MetagenomeSeq home page](https://bioconductor.org/packages/release/bioc/html/metagenomeSeq.html)",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Unpaired reads that didn't align",
            "description": "Writes unpaired reads that didn't align to the reference in the output file.",
            "id": "#unaligned_unpaired_reads",
            "sbg:toolDefaultValue": "T",
            "sbg:stageInput": null,
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Paired reads not aligned concordantly",
            "description": "Writes pairs that didn't align concordantly to the output file",
            "id": "#un_conc",
            "sbg:toolDefaultValue": "TXT",
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Trim from 5'",
            "description": "Trim specific number of bases from 5' (left) end of each read before alignment (default: 0).",
            "id": "#trim_from_5",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0",
            "sbg:altPrefix": "-5",
            "inputBinding": {
                "separate": true,
                "prefix": "--trim5",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Trim from 3'",
            "description": "Trim specific number of bases from 3' (right) end of each read before alignment.",
            "id": "#trim_from_3",
            "sbg:toolDefaultValue": "0",
            "sbg:altPrefix": "-3",
            "inputBinding": {
                "separate": true,
                "prefix": "--trim3",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Time",
            "description": "Print the wall-clock time required to load the index files and align the reads. This is printed to the \"standard error\" (\"stderr\") filehandle.",
            "id": "#time",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "Off",
            "sbg:altPrefix": "-t",
            "inputBinding": {
                "separate": true,
                "prefix": "--time",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output options"
        },
        {
            "type": [
                "null",
                "string"
            ],
            "label": "Columns in tabular format",
            "description": "Columns in tabular format, comma separated.",
            "id": "#tab_fmt_cols",
            "sbg:toolDefaultValue": "readID,seqID,taxID,score,2ndBestScore,hitLength,queryLength,numMatches",
            "inputBinding": {
                "separate": true,
                "prefix": "--tab-fmt-cols",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Skip the first n reads",
            "description": "Skip (do not align) the first n reads or pairs in the input.",
            "id": "#skip_n_reads",
            "sbg:stageInput": null,
            "sbg:altPrefix": "-s",
            "inputBinding": {
                "separate": true,
                "prefix": "--skip",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Quiet",
            "description": "Print nothing besides alignments and serious errors.",
            "id": "#quiet",
            "sbg:stageInput": null,
            "inputBinding": {
                "separate": true,
                "prefix": "--quiet",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output options"
        },
        {
            "type": [
                "null",
                {
                    "type": "enum",
                    "symbols": [
                        "FASTQ (.fq/.fastq)",
                        "QSEQ",
                        "FASTA (.fa/.mfa)",
                        "raw-one-sequence-per-line",
                        "comma-separated-lists"
                    ],
                    "name": "query_input_files"
                }
            ],
            "label": "Query input files",
            "description": "Query input files can be in FASTQ, (multi-) FASTA or QSEQ format, or one line per read.",
            "id": "#query_input_files",
            "sbg:toolDefaultValue": ".fq/.fastq",
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                {
                    "type": "enum",
                    "symbols": [
                        "Phred+33",
                        "Phred+64",
                        "Integers"
                    ],
                    "name": "quality"
                }
            ],
            "label": "Quality scale",
            "description": "Input qualities are ASCII chars equal to Phred+33 or Phred+64 encoding, or ASCII integers (which are treated as being on the Phred quality scale).",
            "id": "#quality",
            "sbg:toolDefaultValue": "Phred+33",
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "QC filter",
            "description": "Filters out reads that are bad according to QSEQ filter.",
            "id": "#qc_filter",
            "sbg:toolDefaultValue": "Off",
            "inputBinding": {
                "separate": true,
                "prefix": "--qc-filter",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Other"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Parallel threads",
            "description": "Launch NTHREADS parallel search threads (default: 1). Threads will run on separate processors/cores and synchronize when parsing reads and outputting alignments. Searching for alignments is highly parallel, and speedup is close to linear. Increasing -p increases Centrifuge's memory footprint. E.g. when aligning to a human genome index, increasing -p from 1 to 8 increases the memory footprint by a few hundred megabytes. This option is only available if bowtie is linked with the pthreads library (i.e. if BOWTIE_PTHREADS=0 is not specified at build time).",
            "id": "#parallel_threads",
            "sbg:toolDefaultValue": "1",
            "sbg:altPrefix": "--threads",
            "inputBinding": {
                "separate": true,
                "prefix": "-p",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Performance options"
        },
        {
            "type": [
                "null",
                "string"
            ],
            "label": "Output format",
            "description": "Define output format, either 'tab' or 'sam'.",
            "id": "#out_fmt",
            "sbg:toolDefaultValue": "tab",
            "inputBinding": {
                "separate": true,
                "prefix": "--out-fmt",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "No reverse complement",
            "description": "Do not align reverse-complement version of the read.",
            "id": "#norc",
            "sbg:toolDefaultValue": "Off",
            "inputBinding": {
                "separate": true,
                "prefix": "--norc",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "No forward version",
            "description": "Do not align forward (original) version of the read.",
            "id": "#nofw",
            "sbg:toolDefaultValue": "Off",
            "inputBinding": {
                "separate": true,
                "prefix": "--nofw",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Minimum summed length",
            "description": "Minimum summed length of partial hits per read.",
            "id": "#min_totallen",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0",
            "inputBinding": {
                "separate": true,
                "prefix": "--min-totallen",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Classification"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Minimum length of partial hits",
            "description": "Minimum length of partial hits, which must be greater than 15.",
            "id": "#min_hitlen",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "22",
            "inputBinding": {
                "separate": true,
                "prefix": "--min-hitlen",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Classification"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Metrics standard error",
            "description": "Write centrifuge metrics to the \"standard error\" (\"stderr\") filehandle. This is not mutually exclusive with --met-file. Having alignment metric can be useful for debugging certain problems, especially performance issues.",
            "id": "#metrics_standard_error",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "Metrics disabled",
            "inputBinding": {
                "separate": true,
                "prefix": "--met-stderr",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output options"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Metrics",
            "description": "Write a new centrifuge metrics record every <int> seconds. Only matters if either --met-stderr or --met-file are specified.",
            "id": "#met",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "1",
            "inputBinding": {
                "separate": true,
                "prefix": "--met",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Output options"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Memory per job",
            "description": "Amount of RAM memory (in MB) to be used per job.",
            "id": "#memory_per_job",
            "sbg:toolDefaultValue": "4096",
            "sbg:category": "Execution"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Memory mapping",
            "description": "Use memory-mapped I/O to load the index, rather than typical file I/O. Memory-mapping allows many concurrent bowtie processes on the same computer to share the same memory image of the index (i.e. you pay the memory overhead just once). This facilitates memory-efficient parallelization of bowtie in situations where using -p is not possible or not preferable.",
            "id": "#memory_mapping",
            "sbg:stageInput": null,
            "inputBinding": {
                "separate": true,
                "prefix": "--mm",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Performance options"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Ignore qualities",
            "description": "Treat all quality values as 30 on Phred scale.",
            "id": "#ignore_quals",
            "sbg:toolDefaultValue": "False",
            "inputBinding": {
                "separate": true,
                "prefix": "--ignore-quals",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Host taxids",
            "description": "A comma-separated list of taxonomic IDs that will be preferred in classification procedure. The descendants from these IDs will also be preferred. In case some of a read's assignments correspond to these taxonomic IDs, only those corresponding assignments will be reported.",
            "id": "#host_taxids",
            "inputBinding": {
                "separate": true,
                "prefix": "--host-taxids",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Classification"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Exclude taxids",
            "description": "A comma-separated list of taxonomic IDs that will be excluded in classification procedure. The descendants from these IDs will also be exclude.",
            "id": "#exclude_taxids",
            "inputBinding": {
                "separate": true,
                "prefix": "--exclude-taxids",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Classification"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Unpaired reads that aligned at least once",
            "description": "Writes unpaired reads that aligned at least once to the output file.",
            "id": "#aligned_unpaired_reads",
            "sbg:toolDefaultValue": "TXT",
            "sbg:stageInput": null,
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "int"
            ],
            "label": "Align first n reads",
            "description": "Align the first n reads or read pairs from the input (after the -s/--skip reads or pairs have been skipped), then stop.",
            "id": "#align_first_n_reads",
            "sbg:toolDefaultValue": "No limit",
            "sbg:altPrefix": "-u",
            "inputBinding": {
                "separate": true,
                "prefix": "--upto",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "boolean"
            ],
            "label": "Paired reads aligned concordantly",
            "description": "Writes pairs that aligned concordantly at least once to the output file.",
            "id": "#al_conc",
            "sbg:toolDefaultValue": "TXT",
            "sbg:category": "Output"
        },
        {
            "type": [
                "null",
                "string"
            ],
            "label": "SRA accession number",
            "description": "Comma-separated list of SRA accession numbers, e.g. --sra-acc SRR353653,SRR353654. Information about read types is available at http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?sp=runinfo&acc=sra-acc&retmode=xml, where sra-acc is SRA accession number. If users run HISAT2 on a computer cluster, it is recommended to disable SRA-related caching (see the instruction at SRA-MANUAL).",
            "id": "#SRA_accession_number",
            "inputBinding": {
                "separate": true,
                "prefix": "--sra-acc",
                "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
        },
        {
            "type": [
                "null",
                "string"
            ],
            "label": "Taxonomy IDs",
            "description": "Only download the specified taxonomy IDs, comma separated. Default: any.",
            "id": "#taxids",
            "doc": "Only download the specified taxonomy IDs, comma separated. Default: any.",
            "sbg:x": -273.9319763183594,
            "sbg:y": 96.6802749633789,
            "sbg:includeInPorts": true
        },
        {
            "type": [
                "null",
                {
                    "type": "array",
                    "items": {
                        "type": "enum",
                        "name": "domain",
                        "symbols": [
                            "bacteria",
                            "viral",
                            "archaea",
                            "fungi",
                            "protozoa",
                            "invertebrate",
                            "plant",
                            "vertebrate_mammalian",
                            "vertebrate_other"
                        ]
                    }
                }
            ],
            "label": "Domain to download",
            "description": "What domain to download. One or more of bacteria, viral, archaea, fungi, protozoa, invertebrate, plant, vertebrate_mammalian, vertebrate_other.",
            "id": "#domain",
            "doc": "What domain to download. One or more of bacteria, viral, archaea, fungi, protozoa, invertebrate, plant, vertebrate_mammalian, vertebrate_other.",
            "sbg:x": -277,
            "sbg:y": 373.4421691894531,
            "sbg:includeInPorts": true
        },
        {
            "type": [
                "null",
                "string"
            ],
            "label": "Refseq category",
            "description": "Only download genomes in the specified refseq category. Default: any.",
            "id": "#refseq_category",
            "doc": "Only download genomes in the specified refseq category. Default: any.",
            "sbg:x": -273.80950927734375,
            "sbg:y": 231.8095245361328,
            "sbg:includeInPorts": true
        },
        {
            "type": [
                {
                    "type": "array",
                    "items": "File"
                }
            ],
            "label": "Metagenomic samples",
            "description": "List of the FASTQ files with properly set metadata fileds.",
            "sbg:fileTypes": "FASTQ, FQ, FASTQ.GZ, FQ.GZ",
            "id": "#fastq_list",
            "doc": "List of the FASTQ files with properly set metadata fileds.",
            "sbg:x": -271.1308288574219,
            "sbg:y": -110.95787048339844,
            "sbg:includeInPorts": true
        }
    ],
    "outputs": [
        {
            "id": "#Centrifuge_report",
            "label": "Centrifuge report",
            "description": "Centrifuge report.",
            "source": [
                "#Centrifuge_Classifier.Centrifuge_report"
            ],
            "type": [
                "null",
                "File"
            ],
            "sbg:fileTypes": "TSV",
            "required": false,
            "sbg:x": 765.506103515625,
            "sbg:y": -64.8891372680664,
            "sbg:includeInPorts": true
        }
    ],
    "steps": [
        {
            "id": "#Centrifuge_Classifier",
            "inputs": [
                {
                    "id": "#Centrifuge_Classifier.unaligned_unpaired_reads",
                    "source": "#unaligned_unpaired_reads"
                },
                {
                    "id": "#Centrifuge_Classifier.un_conc",
                    "source": "#un_conc"
                },
                {
                    "id": "#Centrifuge_Classifier.trim_from_5",
                    "source": "#trim_from_5"
                },
                {
                    "id": "#Centrifuge_Classifier.trim_from_3",
                    "source": "#trim_from_3"
                },
                {
                    "id": "#Centrifuge_Classifier.time",
                    "source": "#time"
                },
                {
                    "id": "#Centrifuge_Classifier.tab_fmt_cols",
                    "source": "#tab_fmt_cols"
                },
                {
                    "id": "#Centrifuge_Classifier.skip_n_reads",
                    "source": "#skip_n_reads"
                },
                {
                    "id": "#Centrifuge_Classifier.quiet",
                    "source": "#quiet"
                },
                {
                    "id": "#Centrifuge_Classifier.query_input_files",
                    "source": "#query_input_files"
                },
                {
                    "id": "#Centrifuge_Classifier.quality",
                    "source": "#quality"
                },
                {
                    "id": "#Centrifuge_Classifier.qc_filter",
                    "source": "#qc_filter"
                },
                {
                    "id": "#Centrifuge_Classifier.parallel_threads",
                    "source": "#parallel_threads"
                },
                {
                    "id": "#Centrifuge_Classifier.out_fmt",
                    "source": "#out_fmt"
                },
                {
                    "id": "#Centrifuge_Classifier.norc",
                    "source": "#norc"
                },
                {
                    "id": "#Centrifuge_Classifier.nofw",
                    "source": "#nofw"
                },
                {
                    "id": "#Centrifuge_Classifier.min_totallen",
                    "source": "#min_totallen"
                },
                {
                    "id": "#Centrifuge_Classifier.min_hitlen",
                    "source": "#min_hitlen"
                },
                {
                    "id": "#Centrifuge_Classifier.metrics_standard_error",
                    "source": "#metrics_standard_error"
                },
                {
                    "id": "#Centrifuge_Classifier.met",
                    "source": "#met"
                },
                {
                    "id": "#Centrifuge_Classifier.memory_per_job",
                    "source": "#memory_per_job"
                },
                {
                    "id": "#Centrifuge_Classifier.memory_mapping",
                    "source": "#memory_mapping"
                },
                {
                    "id": "#Centrifuge_Classifier.input_file",
                    "source": [
                        "#SBG_Pair_FASTQs_by_Metadata.tuple_list"
                    ]
                },
                {
                    "id": "#Centrifuge_Classifier.ignore_quals",
                    "source": "#ignore_quals"
                },
                {
                    "id": "#Centrifuge_Classifier.host_taxids",
                    "source": "#host_taxids"
                },
                {
                    "id": "#Centrifuge_Classifier.exclude_taxids",
                    "source": "#exclude_taxids"
                },
                {
                    "id": "#Centrifuge_Classifier.centrifuge_index_archive",
                    "source": "#centrifuge_build.index_tar"
                },
                {
                    "id": "#Centrifuge_Classifier.aligned_unpaired_reads",
                    "source": "#aligned_unpaired_reads"
                },
                {
                    "id": "#Centrifuge_Classifier.align_first_n_reads",
                    "source": "#align_first_n_reads"
                },
                {
                    "id": "#Centrifuge_Classifier.al_conc",
                    "source": "#al_conc"
                },
                {
                    "id": "#Centrifuge_Classifier.SRA_accession_number",
                    "source": "#SRA_accession_number"
                }
            ],
            "outputs": [
                {
                    "id": "#Centrifuge_Classifier.unaligned_unpaired_reads_output"
                },
                {
                    "id": "#Centrifuge_Classifier.un_conc_output"
                },
                {
                    "id": "#Centrifuge_Classifier.aligned_unpaired_reads_output"
                },
                {
                    "id": "#Centrifuge_Classifier.al_conc_output"
                },
                {
                    "id": "#Centrifuge_Classifier.Classification_result"
                },
                {
                    "id": "#Centrifuge_Classifier.Centrifuge_report"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "h-6ae7f9dc/h-66f9662c/h-be5dcb83/0",
                "label": "Centrifuge Classifier",
                "description": "**Centrifuge Classifier** is the main component of the Centrifuge suite, used for classification of metagenomics reads. Upon building (or downloading) and inspecting an Index (if desired), this tool can be used to process samples of interest. It can be used as a standalone tool, or as a part of **Metagenomics WGS analysis** workflow.\n\n**Centrifuge** is a novel microbial classification engine that enables rapid, accurate, and sensitive labeling of reads and quantification of species present in metagenomic samples. The system uses a novel indexing scheme based on the Burrows-Wheeler transform (BWT) and the Ferragina-Manzini (FM) index, optimized specifically for the metagenomic classification problem [1]. \n\n\nThe **Centrifuge Classifier** tool requires the following input files:\n\n- **Input reads** files with metagenomic reads - they can be in FASTQ or FASTA format, gzip-ed (extension .GZ) or bzip2-ed (extension .BZ2); in case of host-associated samples, it is presumed that files are already cleaned from  the host's genomic sequences;\n- **Reference index** in TAR format; for larger indexes the TAR.GZ format can be used, in this case we suggest the user manually set the required memory for the **Centrifuge Classifier** job by changing the value for the **Memory per job** parameter.\n\nThe results of the classification process are presented in two output files:\n\n- **Centrifuge report**, a tab delimited text file with containing results of an analysis for each taxonomic category from the reference organized into eight columns: (1) ID of a read, (2) sequence ID of the genomic sequence where the read is classified, (3) taxonomic ID of the genomic sequence from the second column, (4) the score of the classification, (5) the score for the next best classification, (6) an approximate number of base pairs of the read that match the genomic sequence, (7) the length of a read, and (8) the number of classifications for this read. The resulting line per read looks like the following:   \n     `HWUSI-EAS688_103028660:7:100:10014:18930 NC_020104.1 1269028 81 0 24 200 1`\n\n- **Classification result**, a tab delimited file with a classification summary for each genome or taxonomic unit from the reference index organized into seven columns: (1) the name of a genome, (2) taxonomic ID, (3) taxonomic rank, (4) the length of the genome sequence, (5) the number of reads classified to the provided genomic sequences, including multi-classified, (6) the number of reads uniquely classified to this particular genomic sequence, (7) the proportion of this genome normalized by its genomic length. The resulting line per genome looks like the following:   \n     `Streptococcus phage 20617 1392231 species 48800 1436 1325 0.453983`\n\n\nBased on the `--met-file` parameter value, **Centrifuge Classifier** can produce an additional output file with alignment metrics. However, it seems that this option does not work properly (see *Common Issues and Important Notes*). We suggest excluding it.\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Centrifuge Classifier** takes files from the **Input reads** input node with raw reads (presumably cleaned from host genomic sequences as recommended by [Human Microbiome Project](https://hmpdacc.org/)) and one reference index file (in TAR ot TAR.GZ format) with microbial reference sequences. Based on the k-mer exact matching algorithm, Centrifuge assigns scores for each species on which k-mers from the read are aligned, and afterwards traverses upwards along the taxonomic tree to reduce the number of assignments, first by considering the genus that includes the largest number of species and then replacing those species with the genus. For more details on Centrifuge's algorithm see [1].\nThe results of the classification analysis are given for each reference sequence (in the **Classification result** file) and for each read (in the **Centrifuge report** file).\n\nThe index used in the analysis is Centrifuge's FM-index, whose size is reduced by compressing redundant genomic sequences. It can be downloaded from [Centrifuge's website](https://ccb.jhu.edu/software/centrifuge/manual.shtml) or created with the **Centrifuge Build** tool and/or the **Reference Index Creation workflow** provided by the Seven Bridges platform. In either case, it must be in the appropriate format (this can be checked with the **Centrifuge Inspect** tool). Based on our experience, an index should contain all of the organisms that are expected to be present in the sample. Providing an index with a smaller number of organisms (for example, in cases when the user is just interested in detecting one particular species) can result in miscalculated abundances of organisms within the sample.\n\n\n### Changes Introduced by Seven Bridges\n\n* **Centrifuge Classifier options** `--un`, `--un-conc`, `--al`, `--al-conc` and `--met-file` do not work properly, therefore all of them are excluded from the Seven Bridges version of the tool. In case a new release of the tool addresses these issues, an updated Seven Bridges version of the tool will be released as well.\n* The tool will automatically extract the index TAR file into the working directory and the basename from the **Reference genome** metadata field will be passed to **Centrifuge Classifier** using the `-x` argument.\n\n### Common Issues and Important Notes\n\n* If the index is in TAR.GZ format, the memory for **Centrifuge Classifier** should be set manually by changing the default value for the **Memory per job** parameter (in MB). Based on our experience, it would be enough to use twice as much memory as the size of the index file, with an additional 4GB overhead. For example, if the size of the index file is 8GB, the user should use 8 x 2 + 4 = 20GB, which amounts to 20 x 1024 = 20480MB.\n\n### Performance Benchmarking\n\n**Centrifuge Classifier** requires a significant amount of memory (based on our experience 4GB more than the size of the index files is suggested) in order to work properly. If the index is in TAR format, the tool will automatically allocate the required memory size. However, if the index is in TAR.GZ format, where the compression ratio is not always the same, we suggest the user manually set the required amount of memory necessary for the **Centrifuge Classifier** job. This can be done by changing the default **Memory per job** parameter value. This way, using expensive and memory overqualified instances, task failures would be avoided.\n\nIn the following table you can find estimates of **Centrifuge Classifier** running time and cost. All experiments are done with one sample. \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Experiment type | Input size | Duration | Cost | Instance (AWS)\n| --- | --- | --- | --- | --- |\n|p_h_v index (prokaryotic, human and viral genomes)|Index 6.9 GB, reads SRS013942 sample 2 x 1 GB| 11m| $ 0.11 | c4.2xlarge|\n|Viral index |Index 118 MB, reads SRS013942 sample 2 x 1 GB| 5m| $ 0.07 | c4.2xlarge|\n|Bacterial index |Index 13GB, reads SRS013942 sample 2 x 1 GB | 16m| $ 0.25 | c4.4xlarge|\n|Bacterial index |Index 13GB, reads SRS019027 sample 2 x 3.5 GB | 27m| $ 0.42 | c4.4xlarge|\n\n\n### References\n[1] Kim D, Song L, Breitwieser FP, and Salzberg SL. [Centrifuge: rapid and sensitive classification of metagenomic sequences](http://genome.cshlp.org/content/early/2016/11/16/gr.210641.116.abstract). Genome Research 2016",
                "baseCommand": [
                    {
                        "class": "Expression",
                        "script": "{\n  index_file = $job.inputs.centrifuge_index_archive.path\n  return \"tar -xvf \" + index_file + \"; \" + \"basename=$(ls | grep '.cf$' | head -1 | cut -d '.' -f 1); \"\n  \n}",
                        "engine": "#cwl-js-engine"
                    },
                    "centrifuge"
                ],
                "inputs": [
                    {
                        "sbg:toolDefaultValue": "T",
                        "sbg:stageInput": null,
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Unpaired reads that didn't align",
                        "description": "Writes unpaired reads that didn't align to the reference in the output file.",
                        "id": "#unaligned_unpaired_reads"
                    },
                    {
                        "sbg:toolDefaultValue": "TXT",
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Paired reads not aligned concordantly",
                        "description": "Writes pairs that didn't align concordantly to the output file",
                        "id": "#un_conc"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:altPrefix": "-5",
                        "sbg:stageInput": null,
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim5",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 5'",
                        "description": "Trim specific number of bases from 5' (left) end of each read before alignment (default: 0).",
                        "id": "#trim_from_5"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:altPrefix": "-3",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim3",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 3'",
                        "description": "Trim specific number of bases from 3' (right) end of each read before alignment.",
                        "id": "#trim_from_3"
                    },
                    {
                        "sbg:toolDefaultValue": "Off",
                        "sbg:altPrefix": "-t",
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--time",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Time",
                        "description": "Print the wall-clock time required to load the index files and align the reads. This is printed to the \"standard error\" (\"stderr\") filehandle.",
                        "id": "#time"
                    },
                    {
                        "sbg:toolDefaultValue": "readID,seqID,taxID,score,2ndBestScore,hitLength,queryLength,numMatches",
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--tab-fmt-cols",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Columns in tabular format",
                        "description": "Columns in tabular format, comma separated.",
                        "id": "#tab_fmt_cols"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:altPrefix": "-s",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--skip",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip the first n reads",
                        "description": "Skip (do not align) the first n reads or pairs in the input.",
                        "id": "#skip_n_reads"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--quiet",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Quiet",
                        "description": "Print nothing besides alignments and serious errors.",
                        "id": "#quiet"
                    },
                    {
                        "sbg:toolDefaultValue": ".fq/.fastq",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "FASTQ (.fq/.fastq)",
                                    "QSEQ",
                                    "FASTA (.fa/.mfa)",
                                    "raw-one-sequence-per-line",
                                    "comma-separated-lists"
                                ],
                                "name": "query_input_files"
                            }
                        ],
                        "label": "Query input files",
                        "description": "Query input files can be in FASTQ, (multi-) FASTA or QSEQ format, or one line per read.",
                        "id": "#query_input_files"
                    },
                    {
                        "sbg:toolDefaultValue": "Phred+33",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Phred+33",
                                    "Phred+64",
                                    "Integers"
                                ],
                                "name": "quality"
                            }
                        ],
                        "label": "Quality scale",
                        "description": "Input qualities are ASCII chars equal to Phred+33 or Phred+64 encoding, or ASCII integers (which are treated as being on the Phred quality scale).",
                        "id": "#quality"
                    },
                    {
                        "sbg:toolDefaultValue": "Off",
                        "sbg:category": "Other",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--qc-filter",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "QC filter",
                        "description": "Filters out reads that are bad according to QSEQ filter.",
                        "id": "#qc_filter"
                    },
                    {
                        "sbg:toolDefaultValue": "1",
                        "sbg:altPrefix": "--threads",
                        "sbg:category": "Performance options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-p",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Parallel threads",
                        "description": "Launch NTHREADS parallel search threads (default: 1). Threads will run on separate processors/cores and synchronize when parsing reads and outputting alignments. Searching for alignments is highly parallel, and speedup is close to linear. Increasing -p increases Centrifuge's memory footprint. E.g. when aligning to a human genome index, increasing -p from 1 to 8 increases the memory footprint by a few hundred megabytes. This option is only available if bowtie is linked with the pthreads library (i.e. if BOWTIE_PTHREADS=0 is not specified at build time).",
                        "id": "#parallel_threads"
                    },
                    {
                        "sbg:toolDefaultValue": "tab",
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--out-fmt",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output format",
                        "description": "Define output format, either 'tab' or 'sam'.",
                        "id": "#out_fmt"
                    },
                    {
                        "sbg:toolDefaultValue": "Off",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--norc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "No reverse complement",
                        "description": "Do not align reverse-complement version of the read.",
                        "id": "#norc"
                    },
                    {
                        "sbg:toolDefaultValue": "Off",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--nofw",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "No forward version",
                        "description": "Do not align forward (original) version of the read.",
                        "id": "#nofw"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:stageInput": null,
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--min-totallen",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum summed length",
                        "description": "Minimum summed length of partial hits per read.",
                        "id": "#min_totallen"
                    },
                    {
                        "sbg:toolDefaultValue": "22",
                        "sbg:stageInput": null,
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--min-hitlen",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum length of partial hits",
                        "description": "Minimum length of partial hits, which must be greater than 15.",
                        "id": "#min_hitlen"
                    },
                    {
                        "sbg:toolDefaultValue": "Metrics disabled",
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--met-stderr",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Metrics standard error",
                        "description": "Write centrifuge metrics to the \"standard error\" (\"stderr\") filehandle. This is not mutually exclusive with --met-file. Having alignment metric can be useful for debugging certain problems, especially performance issues.",
                        "id": "#metrics_standard_error"
                    },
                    {
                        "sbg:toolDefaultValue": "1",
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--met",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Metrics",
                        "description": "Write a new centrifuge metrics record every <int> seconds. Only matters if either --met-stderr or --met-file are specified.",
                        "id": "#met"
                    },
                    {
                        "sbg:toolDefaultValue": "4096",
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Amount of RAM memory (in MB) to be used per job.",
                        "id": "#memory_per_job"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Performance options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--mm",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Memory mapping",
                        "description": "Use memory-mapped I/O to load the index, rather than typical file I/O. Memory-mapping allows many concurrent bowtie processes on the same computer to share the same memory image of the index (i.e. you pay the memory overhead just once). This facilitates memory-efficient parallelization of bowtie in situations where using -p is not possible or not preferable.",
                        "id": "#memory_mapping"
                    },
                    {
                        "required": true,
                        "sbg:category": "Input files",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "inputBinding": {
                            "position": 5,
                            "separate": true,
                            "itemSeparator": " ",
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()\n  ext = filename.substr(filename.lastIndexOf('.') + 1)\n\n  if (ext === \"fa\" || ext === \"fasta\")\n  {\n    return \"-f \" \n  }\n  else if (ext === \"fq\" || ext === \"fastq\")\n  {\n    return \"-q \" \n  }\n}\n\n",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Input reads",
                        "description": "Read sequence in FASTQ or FASTA format. Could be also gzip'ed (extension .gz) or bzip2'ed (extension .bz2). In case of paired-end alignment it is crucial to set metadata 'paired-end' field to 1/2.",
                        "sbg:fileTypes": "FASTA, FASTQ, FA, FQ, FASTQ.GZ, FQ.GZ, FASTQ.BZ2, FQ.BZ2",
                        "id": "#input_file"
                    },
                    {
                        "sbg:toolDefaultValue": "False",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--ignore-quals",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Ignore qualities",
                        "description": "Treat all quality values as 30 on Phred scale.",
                        "id": "#ignore_quals"
                    },
                    {
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--host-taxids",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Host taxids",
                        "description": "A comma-separated list of taxonomic IDs that will be preferred in classification procedure. The descendants from these IDs will also be preferred. In case some of a read's assignments correspond to these taxonomic IDs, only those corresponding assignments will be reported.",
                        "id": "#host_taxids"
                    },
                    {
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--exclude-taxids",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude taxids",
                        "description": "A comma-separated list of taxonomic IDs that will be excluded in classification procedure. The descendants from these IDs will also be exclude.",
                        "id": "#exclude_taxids"
                    },
                    {
                        "required": true,
                        "sbg:stageInput": "link",
                        "sbg:category": "Input files",
                        "type": [
                            "File"
                        ],
                        "label": "Reference index",
                        "description": "The basename of the index for the reference genomes. The basename is the name of any of the index files up to but not including the final .1.cf / etc. centrifuge looks for the specified index first in the current directory, then in the directory specified in the CENTRIFUGE_INDEXES environment variable.",
                        "sbg:fileTypes": "TAR, TAR.GZ",
                        "id": "#centrifuge_index_archive"
                    },
                    {
                        "sbg:toolDefaultValue": "TXT",
                        "sbg:stageInput": null,
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Unpaired reads that aligned at least once",
                        "description": "Writes unpaired reads that aligned at least once to the output file.",
                        "id": "#aligned_unpaired_reads"
                    },
                    {
                        "sbg:toolDefaultValue": "No limit",
                        "sbg:altPrefix": "-u",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--upto",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Align first n reads",
                        "description": "Align the first n reads or read pairs from the input (after the -s/--skip reads or pairs have been skipped), then stop.",
                        "id": "#align_first_n_reads"
                    },
                    {
                        "sbg:toolDefaultValue": "TXT",
                        "sbg:category": "Output",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Paired reads aligned concordantly",
                        "description": "Writes pairs that aligned concordantly at least once to the output file.",
                        "id": "#al_conc"
                    },
                    {
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--sra-acc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "SRA accession number",
                        "description": "Comma-separated list of SRA accession numbers, e.g. --sra-acc SRR353653,SRR353654. Information about read types is available at http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?sp=runinfo&acc=sra-acc&retmode=xml, where sra-acc is SRA accession number. If users run HISAT2 on a computer cluster, it is recommended to disable SRA-related caching (see the instruction at SRA-MANUAL).",
                        "id": "#SRA_accession_number"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Unpaired reads that that didn't align",
                        "description": "Output text file containing unpaired unaligned reads.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*unaligned_unpaired_reads.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#unaligned_unpaired_reads_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Pairs that didn't align concordantly",
                        "description": "Output text file containing pairs that did not align concordantly, when un_conc option is selected.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*un_conc*",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#un_conc_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Unpaired reads that aligned at least once",
                        "description": "Output text file containing unpaired reads that aligned at least once.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*_aligned_unpaired_reads.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#aligned_unpaired_reads_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Pairs that aligned concordantly at least once",
                        "description": "Output text file containing pairs that aligned concordantly at least once, when al_conc option is selected.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*al_conc*",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#al_conc_output"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Classification result",
                        "description": "Classification result.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*Classification_result.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#Classification_result"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Centrifuge report",
                        "description": "Centrifuge report.",
                        "sbg:fileTypes": "TSV",
                        "outputBinding": {
                            "glob": "*Centrifuge_report.tsv",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#Centrifuge_report"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ],
                        "id": "#cwl-js-engine"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{\n  if($job.inputs.parallel_threads){\n  \treturn $job.inputs.parallel_threads\n  }\n  return 1\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{  \n  if($job.inputs.memory_per_job){\n  \t\treturn $job.inputs.memory_per_job\n\t}\n\telse {\n      \tinput_size = $job.inputs.centrifuge_index_archive.size\n        input_MB = input_size/1048576\n       \n        \n        if ($job.inputs.centrifuge_index_archive.path.split('.').pop()==\"gz\"){\n          return 2*Math.ceil(input_MB) + 4096\n          \n        }\n      \telse {\n        \treturn Math.ceil(input_MB) + 4096\n          \n        }\n      \n\t}\n\n}\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/centrifuge:1.0.3_feb2018"
                    }
                ],
                "arguments": [
                    {
                        "position": 1,
                        "prefix": "-x",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  return \"$basename\"\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 5,
                        "separate": false,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  cmd = \"\"\n  reads = [].concat($job.inputs.input_file)\n  reads1 = [];\n  reads2 = [];\n  u_reads = [];\n  for (var i = 0; i < reads.length; i++){\n      if (reads[i].metadata.paired_end == 1){\n        reads1.push(reads[i].path);\n      }\n      else if (reads[i].metadata.paired_end == 2){\n        reads2.push(reads[i].path);\n      }\n    else {\n      u_reads.push(reads[i].path);\n     }\n    }\n  if (reads1.length > 0 & reads1.length == reads2.length){\n      cmd = \"-1 \" + reads1.join(\",\") + \" -2 \" + reads2.join(\",\");\n  }\n  if (u_reads.length > 0){\n      cmd = \" -U \" + u_reads.join(\",\");\n  }\n  return cmd\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 6,
                        "prefix": "-S",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Classification_result.txt\" \n  \n  return new_filename;\n}\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--report-file",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_report.tsv\" \n  \n  return new_filename;\n}\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n\n  if ($job.inputs.query_input_files == \"FASTQ\")\n  {\n    return \"-q\" \n  }\n  else if ($job.inputs.query_input_files == \"QSEQ\")\n  {\n    return \"-qseq\" \n  }\n  else if ($job.inputs.query_input_files == \"FASTA\")\n  {\n    return \"-f\" \n  }\n  else if ($job.inputs.query_input_files == \"raw-one-sequence-per-line\")\n  {\n    return \"-r\" \n  }\n  else if ($job.inputs.query_input_files == \"comma-separated-lists\")\n  {\n    return \"-c \" \n  }\n  \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n\n  if ($job.inputs.quality == \"Phred+33\")\n  {\n    return \"--phred33\" \n  }\n  else if ($job.inputs.quality == \"Phred+64\")\n  {\n    return \"--phred64\" \n  }\n  else if ($job.inputs.quality == \"Integers\")\n  {\n    return \"--int-quals\" \n  }\n    \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 10,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  return \"; echo \\\"\" + $job.inputs.centrifuge_index_archive.path.split('.').pop() + \"\\\"\"\n  \n  \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--un-conc",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_un_conc.txt\" \n  \n  if ($job.inputs.un_conc == true)\n  {\n    return new_filename; \n  }\n}\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--al-conc",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_al_conc.txt\" \n  \n  if ($job.inputs.al_conc == true)\n  {\n    return new_filename; \n  }\n}\n\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--al",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_aligned_unpaired_reads.txt\" \n  \n  if ($job.inputs.aligned_unpaired_reads == true)\n  {\n    return new_filename; \n  }\n}\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--un",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_unaligned_unpaired_reads.txt\" \n  \n  if ($job.inputs.unaligned_unpaired_reads == true)\n  {\n    return new_filename; \n  }\n}\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "stdout": "test.log",
                "sbg:publisher": "sbg",
                "sbg:id": "h-6ae7f9dc/h-66f9662c/h-be5dcb83/0",
                "y": 37.06249237060549,
                "sbg:image_url": null,
                "sbg:modifiedBy": "aleksandar_danicic",
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:revision": 15,
                "sbg:copyOf": "aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/85",
                "sbg:latestRevision": 15,
                "sbg:toolkitVersion": "1.0.3",
                "x": 395.00000000000006,
                "sbg:modifiedOn": 1527515180,
                "sbg:categories": [
                    "Metagenomics"
                ],
                "sbg:sbgMaintained": false,
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedOn": 1502187693,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/31"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedOn": 1503655771,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/34"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedOn": 1504617993,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/35"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedOn": 1505397312,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/36"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedOn": 1505398713,
                        "sbg:modifiedBy": "aleksandar_danicic",
                        "sbg:revisionNotes": "memory per job script changed"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedOn": 1505399113,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/37"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedOn": 1509094768,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/44"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedOn": 1509100749,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/45"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedOn": 1509378923,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/46"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedOn": 1509385038,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/47"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedOn": 1509618489,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/53"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedOn": 1510583750,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/69"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedOn": 1510928893,
                        "sbg:modifiedBy": "vesna_pajic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/70"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedOn": 1511361820,
                        "sbg:modifiedBy": "aleksandar_danicic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/73"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedOn": 1527090677,
                        "sbg:modifiedBy": "aleksandar_danicic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/83"
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedOn": 1527515180,
                        "sbg:modifiedBy": "aleksandar_danicic",
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/85"
                    }
                ],
                "sbg:project": "vesna_pajic/centrifuge-1-0-3-demo",
                "sbg:toolkit": "centrifuge",
                "sbg:job": {
                    "allocatedResources": {
                        "mem": 18212,
                        "cpu": 1
                    },
                    "inputs": {
                        "unaligned_unpaired_reads": true,
                        "trim_from_5": null,
                        "skip_n_reads": null,
                        "input_file": [
                            {
                                "class": "File",
                                "secondaryFiles": [],
                                "path": "/path/to/input_file-1.ext",
                                "size": 0,
                                "metadata": {
                                    "paired_end": "1"
                                }
                            },
                            {
                                "class": "File",
                                "secondaryFiles": [],
                                "path": "/path/to/input_file-2.ext",
                                "size": 0,
                                "metadata": {
                                    "paired_end": "2"
                                }
                            }
                        ],
                        "quiet": false,
                        "parallel_threads": null,
                        "al_conc": true,
                        "out_fmt": "out_fmt-string-value",
                        "exclude_taxids": null,
                        "metrics_standard_error": false,
                        "query_input_files": "FASTQ (.fq/.fastq)",
                        "quality": "Phred+33",
                        "centrifuge_index_archive": {
                            "class": "File",
                            "secondaryFiles": [],
                            "path": "/path/to/centrifuge_index_archive.ext.gz",
                            "size": 7400140800,
                            "metadata": {
                                "reference_genome": "index"
                            }
                        },
                        "tab_fmt_cols": "tab_fmt_cols-string-value",
                        "align_first_n_reads": null,
                        "memory_per_job": null,
                        "min_hitlen": null,
                        "host_taxids": null,
                        "un_conc": true,
                        "memory_mapping": false,
                        "ignore_quals": false,
                        "met": null,
                        "time": false,
                        "nofw": false,
                        "min_totallen": null,
                        "aligned_unpaired_reads": true,
                        "qc_filter": false,
                        "trim_from_3": null,
                        "norc": false,
                        "SRA_accession_number": "SRA_accession_number-string-value"
                    }
                },
                "sbg:createdOn": 1502187693,
                "sbg:projectName": "Centrifuge 1.0.3 Demo",
                "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/85",
                "sbg:createdBy": "vesna_pajic",
                "sbg:contributors": [
                    "aleksandar_danicic",
                    "vesna_pajic"
                ],
                "sbg:validationErrors": [],
                "sbg:cmdPreview": "tar -xvf /path/to/centrifuge_index_archive.ext.gz; basename=$(ls | grep '.cf$' | head -1 | cut -d '.' -f 1);  centrifuge --report-file input_file-1.Centrifuge_report.tsv    --phred33 --un-conc input_file-1.Centrifuge_un_conc.txt --al-conc input_file-1.Centrifuge_al_conc.txt --al input_file-1.Centrifuge_aligned_unpaired_reads.txt --un input_file-1.Centrifuge_unaligned_unpaired_reads.txt -x $basename -1 /path/to/input_file-1.ext -2 /path/to/input_file-2.ext -S input_file-1.Classification_result.txt  ; echo \"gz\" > test.log",
                "sbg:toolAuthor": "John Hopkins University, Center for Computational Biology",
                "sbg:links": [
                    {
                        "id": "https://ccb.jhu.edu/software/centrifuge/manual.shtml",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/infphilo/centrifuge",
                        "label": "Source code"
                    }
                ]
            },
            "label": "Centrifuge Classifier",
            "scatter": "#Centrifuge_Classifier.input_file",
            "sbg:x": 517.0582275390625,
            "sbg:y": -78.12308502197266
        },
        {
            "id": "#SBG_Pair_FASTQs_by_Metadata",
            "inputs": [
                {
                    "id": "#SBG_Pair_FASTQs_by_Metadata.fastq_list",
                    "source": [
                        "#fastq_list"
                    ]
                }
            ],
            "outputs": [
                {
                    "id": "#SBG_Pair_FASTQs_by_Metadata.tuple_list"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "h-5f4b6046/h-a7177b1a/h-a85d3faa/0",
                "label": "SBG Pair FASTQs by Metadata",
                "description": "Tool accepts list of FASTQ files groups them into separate lists. This grouping is done using metadata values and their hierarchy (Sample ID > Library ID > Platform unit ID > File segment number) which should create unique combinations for each pair of FASTQ files. Important metadata fields are Sample ID, Library ID, Platform unit ID and File segment number. Not all of these four metadata fields are required, but the present set has to be sufficient to create unique combinations for each pair of FASTQ files. Files with no paired end metadata are grouped in the same way as the ones with paired end metadata, generally they should be alone in a separate list. Files with no metadata set will be grouped together. \n\nIf there are more than two files in a group, this might create errors further down most pipelines and the user should check if the metadata fields for those files are set properly.",
                "baseCommand": [
                    "echo",
                    "'Pairing",
                    "FASTQs!'"
                ],
                "inputs": [
                    {
                        "sbg:stageInput": "link",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "List of FASTQ files",
                        "description": "List of the FASTQ files with properly set metadata fileds.",
                        "sbg:fileTypes": "FASTQ, FQ, FASTQ.GZ, FQ.GZ",
                        "id": "#fastq_list"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "List of grouped FASTQ files",
                        "description": "List of grouped FASTQ files by metadata fields.",
                        "sbg:fileTypes": "FASTQ, FQ, FASTQ.GZ, FQ.GZ",
                        "outputBinding": {
                            "outputEval": {
                                "class": "Expression",
                                "script": "{\n    function get_meta_map(m, file, meta) {\n        if (meta in file.metadata) {\n            return m[file.metadata[meta]]\n        } else {\n            return m['Undefined']\n        }\n    }\n\n    function create_new_map(map, file, meta) {\n        if (meta in file.metadata) {\n            map[file.metadata[meta]] = {}\n            return map[file.metadata[meta]]\n        } else {\n            map['Undefined'] = {}\n            return map['Undefined']\n        }\n    }\n\n    arr = [].concat($job.inputs.fastq_list)\n    map = {}\n\n    for (i in arr) {\n\n        sm_map = get_meta_map(map, arr[i], 'sample_id')\n        if (!sm_map) sm_map = create_new_map(map, arr[i], 'sample_id')\n\n        lb_map = get_meta_map(sm_map, arr[i], 'library_id')\n        if (!lb_map) lb_map = create_new_map(sm_map, arr[i], 'library_id')\n\n        pu_map = get_meta_map(lb_map, arr[i], 'platform_unit_id')\n        if (!pu_map) pu_map = create_new_map(lb_map, arr[i], 'platform_unit_id')\n\n        if ('file_segment_number' in arr[i].metadata) {\n            if (pu_map[arr[i].metadata['file_segment_number']]) {\n                a = pu_map[arr[i].metadata['file_segment_number']]\n                ar = [].concat(a)\n                ar = ar.concat(arr[i])\n                pu_map[arr[i].metadata['file_segment_number']] = ar\n            } else {\n              pu_map[arr[i].metadata['file_segment_number']] = [].concat(arr[i])\n            }\n        } else {\n            if (pu_map['Undefined']) {\n                a = pu_map['Undefined']\n                ar = [].concat(a)\n                ar = ar.concat(arr[i])\n                pu_map['Undefined'] = ar\n            } else {\n                pu_map['Undefined'] = [].concat(arr[i])\n            }\n        }\n    }\n    tuple_list = []\n    for (sm in map)\n        for (lb in map[sm])\n            for (pu in map[sm][lb]) {\n                for (fsm in map[sm][lb][pu]) {\n                    list = map[sm][lb][pu][fsm]\n                    tuple_list.push(list)\n                }\n            }\n    return tuple_list\n}\n",
                                "engine": "#cwl-js-engine"
                            }
                        },
                        "id": "#tuple_list"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": 1
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": 1024
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "d41a0837ab81",
                        "dockerPull": "images.sbgenomics.com/nikola_jovanovic/alpine:1"
                    }
                ],
                "sbg:publisher": "sbg",
                "sbg:revisionNotes": "Fix for outputEval evaluation failed. Changed map getting to map[a] instead of map.a",
                "sbg:id": "h-5f4b6046/h-a7177b1a/h-a85d3faa/0",
                "sbg:latestRevision": 16,
                "sbg:revision": 16,
                "sbg:image_url": null,
                "sbg:modifiedBy": "admin",
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:license": "Apache License 2.0",
                "sbg:toolAuthor": "",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedOn": 1453799739,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedOn": 1453799740,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedOn": 1453799742,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedOn": 1463578034,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedOn": 1467884288,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedOn": 1468402323,
                        "sbg:modifiedBy": "sevenbridges",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedOn": 1470144392,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Link fastq_list"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedOn": 1472135950,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Added support for single file."
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedOn": 1489512564,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedOn": 1489668743,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedOn": 1498217332,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Fixed a typo."
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedOn": 1505228153,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Fix - error message will appear if files are grouped but have no metadata."
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedOn": 1509554702,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Changed order of pairings (pe1,pe2)."
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedOn": 1509554702,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Changed to JavaScript"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedOn": 1530892323,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Changed docker image to images.sbgenomics.com."
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedOn": 1545924489,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "JS fix for cwl 1.0"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedOn": 1547649687,
                        "sbg:modifiedBy": "admin",
                        "sbg:revisionNotes": "Fix for outputEval evaluation failed. Changed map getting to map[a] instead of map.a"
                    }
                ],
                "sbg:modifiedOn": 1547649687,
                "sbg:categories": [
                    "Converters",
                    "Other"
                ],
                "sbg:sbgMaintained": false,
                "sbg:project": "admin/sbg-public-data",
                "sbg:toolkit": "SBGTools",
                "sbg:job": {
                    "allocatedResources": {
                        "mem": 1024,
                        "cpu": 1
                    },
                    "inputs": {
                        "fastq_list": [
                            {
                                "class": "File",
                                "secondaryFiles": [],
                                "path": "/asda/dsa/sda/sda/fasta1.fastq",
                                "size": 0,
                                "metadata": {
                                    "paired_end": "1",
                                    "sample_id": "a"
                                }
                            },
                            {
                                "secondaryFiles": [],
                                "path": "/asda/dsa/sda/sda/fasta2.fastq",
                                "metadata": {
                                    "paired_end": "2",
                                    "sample_id": "a"
                                }
                            },
                            {
                                "secondaryFiles": [],
                                "path": "/asda/dsa/sda/sda/fasta3.fastq",
                                "metadata": {
                                    "paired_end": "",
                                    "sample_id": "b"
                                }
                            }
                        ]
                    }
                },
                "sbg:createdOn": 1453799739,
                "sbg:projectName": "SBG Public Data",
                "sbg:content_hash": "a6f554d5d8e6a5a567f60e98305dc72a527609b9c3205be984e1fe1712298da1a",
                "sbg:createdBy": "sevenbridges",
                "sbg:contributors": [
                    "admin",
                    "sevenbridges"
                ],
                "sbg:validationErrors": [],
                "sbg:cmdPreview": "echo 'Pairing FASTQs!'"
            },
            "label": "SBG Pair FASTQs by Metadata",
            "sbg:x": 35.862525939941406,
            "sbg:y": -108.31485748291016
        },
        {
            "id": "#centrifuge_build",
            "inputs": [
                {
                    "id": "#centrifuge_build.conversion_table",
                    "source": "#Centrifuge_Download___refseq.seqid2taxid"
                },
                {
                    "id": "#centrifuge_build.taxonomy_tree",
                    "source": "#Centrifuge_Download___taxonomy.nodes"
                },
                {
                    "id": "#centrifuge_build.name_table",
                    "source": "#Centrifuge_Download___taxonomy.names"
                },
                {
                    "id": "#centrifuge_build.input_sequences",
                    "source": [
                        "#Centrifuge_Download___refseq.ref_sequences"
                    ]
                },
                {
                    "id": "#centrifuge_build.basename",
                    "default": "index"
                }
            ],
            "outputs": [
                {
                    "id": "#centrifuge_build.index_tar"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/centrifuge-build/12",
                "label": "Centrifuge Build",
                "description": "**Centrifuge Build** is a part of the Centrifuge suite, used for building an index from a set of DNA sequences [1]. It can be run as a standalone tool or as part of the **Reference Index Creation** workflow.\n\n**Centrifuge** is a novel microbial classification engine that enables rapid, accurate, and sensitive labelling of reads and quantification of species present in metagenomic samples. The system uses a novel indexing scheme based on the Burrows-Wheeler transform (BWT) and the Ferragina-Manzini (FM) index, optimized specifically for the metagenomic classification problem [1].\n\nThe **Centrifuge Build** tool requires the following input files:\n\n- **Conversion table** (`--conversion-table`) - a tab delimited file that maps sequence IDs to taxonomy IDs;\n- **Taxonomy tree** (`--taxonomy-tree`) - a file that maps taxonomy IDs to their parents and respective rank, up to the root of the tree; when using NCBI taxonomy IDs, this will be the nodes.dmp file from ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz, which can be also obtained using **Centrifuge Download**;\n- **Name table** (`--name-table`) - a file that maps taxonomy IDs to a name; when using NCBI taxonomy IDs, names.dmp is the appropriate file;\n- **Reference sequences** - a file specifying the sequences to be used for building the index.\n\nIt outputs one TAR file, containing a set of 3 files with suffixes .1.cf, .2.cf, and .3.cf. These files together constitute the index, which is necessary to align reads to the reference. The original sequence FASTA files are no longer used by Centrifuge once the index is built.\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Centrifuge Build** uses a set of DNA sequences (from the **Reference sequences** input file or the **List of sequences** input argument) to build an index for classifying metagenomic reads. There are some publicly available indexes at Centrifuge's website. However, the number of microbial sequences in public databases are constantly growing, therefore we advise creating new and revised index files from time to time.\n\n### Changes Introduced by Seven Bridges\n\n* No modifications to the original tool representation have been made.\n\n### Common Issues and Important Notes\n\n* **Centrifuge Build** has memory demands that depend on the size of the reference sequences. Due to this, the memory requirement is automatically set to a value higher than seven times the size of the sequences (this value is based on our experience). This should be changed only with good reason. \n\n### Performance Benchmarking\n\nBased on our experience running the tool, the minimal amount of RAM **Centrifuge Build** needs should be at least 6 times more than the size of the input sequences in (**Reference sequences**).\nThis tool is set to use even more RAM (7 times the size of the input sequences), in order to ensure smooth operation. Unless absolutely necessary, this memory setting should not be changed. To find out how to change the instance, please refer to the [documentation](https://docs.sevenbridges.com/docs/set-computation-instances#section-set-the-instance-type-for-a-workflow).\n\n**Centrifuge Build** also requires certain number of threads. Based on the running instance's number of available CPUs, one can set the *Number of threads* parameter to 8, 16, 32, etc. Since all benchmarking experiments were done with bacterial sequences (input files of 36.5 GB), available instances meeting the memory requirements of the **Centrifuge Build** tool are m4.16xlarge (AWS) and r4.16xlarge (AWS). If running time and cost for instances m4.16xlarge (AWS) and r4.16xlarge (AWS) are compared, it can be seen that running **Centrifuge Build** on m4.16xlarge (AWS) is more cost effective.  See the table below for details.\nTherefore, as building the bacterial index is the most demanding task memory-wise, the default instance for **Centrifuge Build** is set to be m4.16xlarge (AWS). However, when building smaller size indices, we recommend using other AWS instances. \n\n*Cost can be significantly reduced by **spot instance** usage. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n| Instance (AWS)|Number of threads | Duration | Cost |\n| --- | --- | --- | --- |\n|m4.16xlarge| 8 | 7h 42m | $25.72 |\n|r4.16xlarge|8| 7h 44m | $ 33.99 |\n|r4.16xlarge|16| 4h 29m | $ 19.70 |\n|r4.16xlarge|32| 4h 1m| $17.67|\n\n\n### References\n\n[1] Kim D, Song L, Breitwieser FP, and Salzberg SL. [Centrifuge: rapid and sensitive classification of metagenomic sequences](http://genome.cshlp.org/content/early/2016/11/16/gr.210641.116.abstract). Genome Research 2016",
                "baseCommand": [
                    "centrifuge-build"
                ],
                "inputs": [
                    {
                        "sbg:category": "Reference",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "List of sequences",
                        "description": "A comma-separated list of sequences instead of a list of FASTA files.",
                        "id": "#sequence_list"
                    },
                    {
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--large-index",
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "Large index",
                        "description": "Force generated index to be 'large', even if reference has fewer than 4 billion nucleotides.",
                        "id": "#large_index"
                    },
                    {
                        "sbg:altPrefix": "-a",
                        "sbg:category": "Speed/memory tradeoff",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--noauto",
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "No automatic memory fitting",
                        "description": "Disable automatic -p/--bmax/--dcv memory fitting.",
                        "id": "#no_auto"
                    },
                    {
                        "sbg:category": "Speed/memory tradeoff",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--bmax",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Maximum number of suffixes",
                        "description": "The maximum number of suffixes allowed in a block. Allowing more suffixes per block makes indexing faster, but increases peak memory usage. Setting this option overrides any previous setting for --bmax, or --bmaxdivn. Default (in terms of the --bmaxdivn parameter) is --bmaxdivn 4. This is configured automatically by default; use -a/--noauto to configure manually.",
                        "id": "#bmax"
                    },
                    {
                        "sbg:toolDefaultValue": "4",
                        "sbg:category": "Speed/memory tradeoff",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--bmaxdivn",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Maximum number of suffixes - fraction of length",
                        "description": "The maximum number of suffixes allowed in a block, expressed as a fraction of the length of the reference. Setting this option overrides any previous setting for --bmax, or --bmaxdivn. Default: --bmaxdivn 4. This is configured automatically by default; use -a/--noauto to configure manually.",
                        "id": "#bamxdivn"
                    },
                    {
                        "sbg:category": "Speed/memory tradeoff",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--dcv",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Period for difference-cover sample",
                        "description": "The period for the difference-cover sample. A larger period yields less memory overhead, but may make suffix sorting slower, especially if repeats are present. Must be a power of 2 no greater than 4096. Default: 1024. This is configured automatically by default; use -a/--noauto to configure manually.",
                        "id": "#dcv"
                    },
                    {
                        "sbg:category": "Speed/memory tradeoff",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--nodc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Do not use difference-cover sample",
                        "description": "Disable use of the difference-cover sample. Suffix sorting becomes quadratic-time in the worst case (where the worst case is an extremely repetitive reference). Default: off.",
                        "id": "#nodc"
                    },
                    {
                        "sbg:altPrefix": "-r",
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--noref",
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "No packed reference portion",
                        "description": "Don't build .3/.4.bt2 (packed reference) portion.",
                        "id": "#no_ref"
                    },
                    {
                        "sbg:altPrefix": "-3",
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--justref",
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "Just reference portion",
                        "description": "Just build .3/.4.bt2 (packed reference) portion.",
                        "id": "#just_ref"
                    },
                    {
                        "sbg:altPrefix": "-o",
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--offrate",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Off-rate for marking positions",
                        "description": "The indexer will mark every 2^<int> rows with their corresponding location on the genome. Marking more rows makes reference-position lookups faster, but requires more memory to hold the annotations at runtime. The default is 5 (every 32th row is marked).",
                        "id": "#off_rate"
                    },
                    {
                        "sbg:altPrefix": "-t",
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--ftabchars",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of chars for initial BW calculation",
                        "description": "The ftab is the lookup table used to calculate an initial Burrows-Wheeler range with respect to the first <int> characters of the query. Default:10.",
                        "id": "#ftabchars"
                    },
                    {
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--seed",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Random number generator seed",
                        "description": "Seed for random number generator.",
                        "id": "#seed"
                    },
                    {
                        "sbg:altPrefix": "-q",
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--quiet",
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "Only error messages",
                        "description": "Print only error messages.",
                        "id": "#quiet"
                    },
                    {
                        "sbg:altPrefix": "-p",
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--threads",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Number of alignment threads to launch. Default: 1.",
                        "id": "#number_of_threads"
                    },
                    {
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--kmer-count",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Kmer count",
                        "description": "Kmer-size for counting the distinct number of k-mers in the input sequences.",
                        "id": "#kmer_count"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 5,
                            "prefix": "--conversion-table",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Conversion table",
                        "description": "A table that converts any id to a taxonomy id.",
                        "id": "#conversion_table"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 10,
                            "prefix": "--taxonomy-tree",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Taxonomy tree",
                        "description": "Taxonomy tree (e.g. nodes.dmp).",
                        "id": "#taxonomy_tree"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 15,
                            "prefix": "--name-table",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Name table",
                        "description": "Names corresponding to taxonomic IDs (e.g. names.dmp).",
                        "id": "#name_table"
                    },
                    {
                        "sbg:category": "Indexing options",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--size-table",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Size table",
                        "description": "List of taxonomic IDs and lengths of the sequences belonging to the same taxonomic IDs.",
                        "id": "#size_table"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Reference sequences",
                        "description": "A comma-separated list of FASTA files containing the reference sequences to be aligned to.",
                        "id": "#input_sequences"
                    },
                    {
                        "sbg:category": "Output options",
                        "type": [
                            "string"
                        ],
                        "inputBinding": {
                            "position": 25,
                            "separate": false,
                            "sbg:cmdInclude": true
                        },
                        "label": "Index base name",
                        "description": "The basename of the index files to write. By default, centrifuge-build writes files named NAME.1.cf, NAME.2.cf, and NAME.3.cf, where NAME is <cf_base>.",
                        "id": "#basename"
                    },
                    {
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Memory for a job on one CPU.",
                        "id": "#memory_per_job"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Index TAR",
                        "description": "TAR archive containing index.",
                        "sbg:fileTypes": "TAR",
                        "outputBinding": {
                            "glob": "*.tar",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "class": "Expression",
                                    "script": "{\n      return $job.inputs.basename\n }",
                                    "engine": "#cwl-js-engine"
                                }
                            }
                        },
                        "id": "#index_tar"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ],
                        "id": "#cwl-js-engine"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "m4.16xlarge;ebs-gp2;1024"
                    },
                    {
                        "class": "sbg:AlibabaCloudInstanceType",
                        "value": "ecs.g5.16xlarge;cloud_ssd;1024"
                    },
                    {
                        "class": "sbg:GoogleInstanceType",
                        "value": "n1-highmem-64;pd-ssd;2000"
                    },
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{\n  if($job.inputs.number_of_threads){\n  \treturn $job.inputs.number_of_threads\n  }\n  return 1\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{  \n  \n\tif($job.inputs.memory_per_job){\n  \t\treturn $job.inputs.memory_per_job\n\t}\n\telse {\n  \t\tinput_size = [].concat($job.inputs.input_sequences)[0].size\n  \t\tinput_MB = input_size/1048576\n  \t\treturn Math.ceil(input_MB) * 7\n\t}\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/centrifuge:1.0.3_feb2018"
                    }
                ],
                "arguments": [
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  if ($job.inputs.sequence_list){\n    // option -c should be added,\n    // and the value of this input should be inserted instead od reference-in list of files\n    return \"-c\"\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 20,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  if ($job.inputs.sequence_list){\n    return $job.inputs.sequence_list\n  }\n  else {\n    files=\"\"\n       \n    if ($job.inputs.input_sequences) {\n      // make an array of files, in case a single file is passed to the tool\n      files_array = [].concat($job.inputs.input_sequences)\n      \n        for(i=0; i< files_array.length; i++){\n          files += files_array[i].path + \" \"\n        }\n    }\n     \n    \n   \treturn files\n  }\n\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 30,
                        "separate": false,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  tar_command=\"&& tar -cf \" + $job.inputs.basename + \".tar \"\n  tar_command += $job.inputs.basename + \".1.cf \"\n  tar_command += $job.inputs.basename + \".2.cf \"\n  tar_command += $job.inputs.basename + \".3.cf \" \n  return tar_command\n}",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "sbg:toolkitVersion": "1.0.3",
                "sbg:image_url": null,
                "sbg:expand_workflow": false,
                "sbg:toolAuthor": "John Hopkins University, Center for Computational Biology",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721130,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/14"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/15"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/16"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/18"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1510650872,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/29"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1513010012,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/30"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1513010012,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/31"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1513010012,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/32"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1527589742,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/33"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1527589742,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/38"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1545145762,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-build/39"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1562836834,
                        "sbg:revisionNotes": "Google instance hint added (n1-highmem-64)"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1562836835,
                        "sbg:revisionNotes": ""
                    }
                ],
                "sbg:categories": [
                    "Metagenomics"
                ],
                "sbg:toolkit": "centrifuge",
                "sbg:job": {
                    "allocatedResources": {
                        "mem": 8,
                        "cpu": 1
                    },
                    "inputs": {
                        "name_table": {
                            "class": "File",
                            "secondaryFiles": [],
                            "path": "/path/to/name_table.ext",
                            "size": 0
                        },
                        "taxonomy_tree": {
                            "class": "File",
                            "secondaryFiles": [],
                            "path": "/path/to/taxonomy_tree.ext",
                            "size": 0
                        },
                        "kmer_count": null,
                        "quiet": false,
                        "sequence_list": "",
                        "dcv": -1,
                        "nodc": false,
                        "number_of_threads": null,
                        "memory_per_job": 8,
                        "no_ref": false,
                        "large_index": false,
                        "no_auto": false,
                        "basename": "basename-string-value",
                        "input_sequences": [
                            {
                                "class": "File",
                                "secondaryFiles": [],
                                "path": "/path/to/input_sequences-1.ext",
                                "size": 123456789
                            }
                        ],
                        "off_rate": null,
                        "bamxdivn": null,
                        "bmax": null,
                        "ftabchars": null,
                        "seed": null,
                        "conversion_table": {
                            "class": "File",
                            "secondaryFiles": [],
                            "path": "/path/to/conversion_table.ext",
                            "size": 0,
                            "metadata": {
                                "reference_genome": "referenca"
                            }
                        },
                        "just_ref": false
                    }
                },
                "sbg:projectName": "SBG Public data",
                "sbg:cmdPreview": "centrifuge-build   --conversion-table /path/to/conversion_table.ext --taxonomy-tree /path/to/taxonomy_tree.ext --name-table /path/to/name_table.ext  /path/to/input_sequences-1.ext  basename-string-value && tar -cf basename-string-value.tar basename-string-value.1.cf basename-string-value.2.cf basename-string-value.3.cf",
                "sbg:links": [
                    {
                        "id": "https://ccb.jhu.edu/software/centrifuge/manual.shtml",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/infphilo/centrifuge",
                        "label": "Source code"
                    }
                ],
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/centrifuge-build/12",
                "sbg:revision": 12,
                "sbg:revisionNotes": "",
                "sbg:modifiedOn": 1562836835,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1509721130,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 12,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a23c3c2416ac93a90db95dc1cac88469ac856a68d9ec06c7245643bc3701a54bd"
            },
            "label": "Centrifuge Build",
            "sbg:x": 334.1836853027344,
            "sbg:y": 138.68707275390625
        },
        {
            "id": "#Centrifuge_Download___taxonomy",
            "inputs": [
                {
                    "id": "#Centrifuge_Download___taxonomy.domain",
                    "default": []
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.database",
                    "default": "taxonomy"
                }
            ],
            "outputs": [
                {
                    "id": "#Centrifuge_Download___taxonomy.names"
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.nodes"
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.emvec"
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.univec"
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.seqid2taxid"
                },
                {
                    "id": "#Centrifuge_Download___taxonomy.ref_sequences"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/centrifuge-download/5",
                "label": "Centrifuge Download",
                "description": "**Centrifuge Download** is part of the Centrifuge suite, used for downloading reference sequences from NCBI, prior to index building. It can be used as a standalone tool, or as part of the **Reference Index Creation** workflow.\n\n\n**Centrifuge** is a novel microbial classification engine that enables rapid, accurate, and sensitive labeling of reads and quantification of species present in metagenomic samples. The system uses a novel indexing scheme based on the Burrows-Wheeler transform (BWT) and the Ferragina-Manzini (FM) index, optimized specifically for the metagenomic classification problem.\n\n\n**Centrifuge Download**  does not take any file inputs. Instead, it has several input parameters (see *Ports* section) that define how and what will be downloaded.The most important parameters are as follows:\n\n* **Domain to download** (`--domain`) - a list of domains that sequences can be downloaded with;\n* **Taxonomy IDs** (`-t`) - a list of taxonomy identifiers for sequences that the user wants to download;\n* **Assembly level** (`-a`) and **Refseq category** (`-c`) - used for filtering the database from which the sequences will be downloaded;\n* **Database to use** - one of four types of databases: \"*taxonomy*\", \"*refseq*\", \"*genbank*\" or \"*contaminants*\".\n\nThe output of the tool depends on the database used:\n\n- **taxonomy** - it takes taxonomy dump from NCBI and creates *nodes.dmp* and *names.dmp* files;\n- **refseq** - downloads a list of arbitrary sequences from NCBI RefSeq. The output is a file with all downloaded sequences;\n- **genbank** - downloads a list of arbitrary sequences from NCBI GenBank. The output is a file  with all downloaded sequences;\n- **contaminants** - gets contaminant sequences from UniVec and EmVec. The outputs are *UniVec.fna* and *EmVec.fna* files.\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Centrifuge Download** is commonly used prior to **Centrifuge Build**, in order to download the sequences from NCBI databases, that will be used for making the index. Regardless of the type of sequences, **Centrifuge Build** needs information about the taxonomy used in the databases. Therefore, it is common practice to first run **Centrifuge Download** with **Database to use** set to \"*taxonomy*\" in order to have accurate *nodes.dmp* and *names.dmp*. Afterwards, **Centrifuge Download** is commonly run with one of the remaining **Database to use** values.\n\n### Changes Introduced by Seven Bridges\n\n* Originally, **Centrifuge Download** produces a set of .FNA files with sequences (for example, if sequences are downloaded from several domains, there will be an output file per domain). However, on the Seven Bridges platform **Centrifuge Download** automatically merges all files into one output file with all sequences.\n\n### Common Issues and Important Notes\n\n* Although none of the parameters are required in general, some combination of parameter values requires that some other parameter is set. For example, if **Database to use** is \"*refseq*\" or \"*genbank*\", then **Domain to download** is required.\n\n### Performance Benchmarking\n\nBased on our experience, depending on the selected domain, it takes between 5 minutes and one hour to download reference sequences from NCBI. Downloading fungal reference sequences takes only 5 minutes (with the cost of $0.05 on instance c4.2xlarge), while viral and bacterial sequences require approximately 40 minutes and an hour (at the cost of $0.30 and $0.50, using the same c4.2xlarge instance), respectively.",
                "baseCommand": [
                    "centrifuge-download"
                ],
                "inputs": [
                    {
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-P",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Number of processes when downloading.",
                        "id": "#number_of_threads"
                    },
                    {
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Folder for downloading",
                        "description": "Folder to which the files are downloaded. If not set, the default name is *download*.",
                        "id": "#download_folder"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": {
                                    "type": "enum",
                                    "name": "domain",
                                    "symbols": [
                                        "bacteria",
                                        "viral",
                                        "archaea",
                                        "fungi",
                                        "protozoa",
                                        "invertebrate",
                                        "plant",
                                        "vertebrate_mammalian",
                                        "vertebrate_other"
                                    ]
                                }
                            }
                        ],
                        "label": "Domain to download",
                        "description": "What domain to download. One or more of bacteria, viral, archaea, fungi, protozoa, invertebrate, plant, vertebrate_mammalian, vertebrate_other.",
                        "id": "#domain"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-a",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-a",
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n\tif ($job.inputs.assembly_level){\n  \t\treturn \"\\\"\" + $self + \"\\\"\"\n    }\n}"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Assembly level",
                        "description": "Only download genomes with the specified assembly level. Default: 'Complete Genome'.",
                        "id": "#assembly_level"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-c",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-c",
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.refseq_category){\n  \treturn \"\\'\" + $self + \"\\'\"\n  }\n}"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Refseq category",
                        "description": "Only download genomes in the specified refseq category. Default: any.",
                        "id": "#refseq_category"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-t",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-t",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Taxonomy IDs",
                        "description": "Only download the specified taxonomy IDs, comma separated. Default: any.",
                        "id": "#taxids"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-r",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-r",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include RNA sequences",
                        "description": "Download RNA sequences, too.",
                        "id": "#rna_sequences"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-u",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-u",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Filter unplaced sequences",
                        "description": "Filter unplaced sequences.",
                        "id": "#filter_unplaced"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-m",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-m",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Mask low-complexity regions",
                        "description": "Mask low-complexity regions using dustmasker. Default: off.",
                        "id": "#mask_low"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-l",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-l",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Modify header",
                        "description": "Modify header to include taxonomy ID. Default: off.",
                        "id": "#modify_header"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-g",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-g",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Download GI map",
                        "description": "Download GI map.",
                        "id": "#download_GI_map"
                    },
                    {
                        "sbg:category": "Database",
                        "type": [
                            {
                                "type": "enum",
                                "symbols": [
                                    "refseq",
                                    "genbank",
                                    "contaminants",
                                    "taxonomy"
                                ],
                                "name": "database"
                            }
                        ],
                        "inputBinding": {
                            "position": 150,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Database to use",
                        "description": "One of refseq, genbank, contaminants or taxonomy. Use refseq or genbank for genomic sequences, contaminants gets contaminant sequences from UniVec and EmVec, taxonomy for taxonomy mappings.",
                        "id": "#database"
                    },
                    {
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Base name for naming the index",
                        "description": "Basename describing the index; used for naming files.",
                        "id": "#basename"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Memory for a job on one CPU.",
                        "id": "#memory_per_job"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Taxonomy names",
                        "description": "Taxonomy names.",
                        "sbg:fileTypes": "DMP",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"names.dmp\"\n  \n}"
                            }
                        },
                        "id": "#names"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Taxonomy nodes",
                        "description": "Taxonomy nodes.",
                        "sbg:fileTypes": "DMP",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"nodes.dmp\"\n  \n}"
                            }
                        },
                        "id": "#nodes"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "EmVec contaminants",
                        "description": "EmVec contaminants.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"contaminants/EmVec.fna\"\n  \n}"
                            }
                        },
                        "id": "#emvec"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "UniVec contaminants",
                        "description": "UniVec contaminants.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"contaminants/UniVec.fna\"\n  \n}"
                            }
                        },
                        "id": "#univec"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "SeqID_to_TaxonomyID",
                        "description": "Sequence ID to taxonomy ID mapping.",
                        "sbg:fileTypes": "MAP",
                        "outputBinding": {
                            "glob": "*.map",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "class": "Expression",
                                    "engine": "#cwl-js-engine",
                                    "script": "{\n  if ($job.inputs.basename){\n    return $job.inputs.basename\n  }\n}"
                                }
                            }
                        },
                        "id": "#seqid2taxid"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Referent sequences",
                        "description": "Referent sequences.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": "*.fna",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "class": "Expression",
                                    "engine": "#cwl-js-engine",
                                    "script": "{\n  if ($job.inputs.basename){\n    return $job.inputs.basename\n  }\n}"
                                }
                            }
                        },
                        "id": "#ref_sequences"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if($job.inputs.number_of_threads){\n  \treturn $job.inputs.number_of_threads\n  }\n  return 1\n}"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.memory_per_job) {\n    return $job.inputs.memory_per_job\n  } else {\n    return 4096\n  }\n}"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/centrifuge:1.0.3_feb2018"
                    }
                ],
                "arguments": [
                    {
                        "position": 200,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.database == \"refseq\" || $job.inputs.database == \"genbank\"){\n    \n    if ($job.inputs.basename){\n      expand_command = \" > \"+ $job.inputs.basename + \".map\"\n    } else {\n      expand_command = \" > seqid2taxid.map\"\n    }\n    \n    if ($job.inputs.download_folder){\n      expand_command += \"; cat \"+ $job.inputs.download_folder+ \"/*/*.fna > \" \n    }\n    else {\n      expand_command += \"; cat download/*/*.fna > \"\n    }\n    \n    if ($job.inputs.basename){\n      expand_command += $job.inputs.basename + \".sequences.fna\"\n    }\n    else {\n      expand_command += \"input-sequences.fna\"\n    }\n    return expand_command\n  }\n}"
                        }
                    },
                    {
                        "position": 100,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n domains = \"\"\nif ($job.inputs.domain) {\n  for (i=0; i< $job.inputs.domain.length; i++){\n    domains += $job.inputs.domain[i] + \",\"\n  }\n  domains = \"-d \\\"\" + domains.substring(0,domains.length-1) +\"\\\"\"\n}\nreturn domains\n}"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "-o",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.download_folder){\n    return $job.inputs.download_folder\n  }\n  else {\n    return \"download\"\n  }\n}"
                        }
                    }
                ],
                "sbg:toolkitVersion": "1.0.3",
                "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/27",
                "sbg:job": {
                    "inputs": {
                        "download_folder": "",
                        "database": "refseq",
                        "rna_sequences": true,
                        "domain": [
                            "archaea",
                            "viral",
                            "fungi"
                        ],
                        "modify_header": true,
                        "mask_low": true,
                        "filter_unplaced": true,
                        "memory_per_job": 6,
                        "assembly_level": "",
                        "refseq_category": "",
                        "download_GI_map": true,
                        "number_of_threads": 5,
                        "taxids": "taxids-string-value",
                        "basename": "basename-string-value"
                    },
                    "allocatedResources": {
                        "cpu": 5,
                        "mem": 6
                    }
                },
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "https://ccb.jhu.edu/software/centrifuge/manual.shtml"
                    },
                    {
                        "label": "Source code",
                        "id": "https://github.com/infphilo/centrifuge"
                    }
                ],
                "sbg:cmdPreview": "centrifuge-download -o download  -d \"archaea,viral,fungi\"  refseq   > basename-string-value.map; cat download/*/*.fna > basename-string-value.sequences.fna",
                "sbg:projectName": "SBG Public data",
                "sbg:image_url": null,
                "sbg:categories": [
                    "Metagenomics"
                ],
                "sbg:toolAuthor": "John Hopkins University, Center for Computational Biology",
                "sbg:toolkit": "centrifuge",
                "sbg:publisher": "sbg",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/14"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/15"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/16"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/18"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1510650872,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/26"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1527589742,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/27"
                    }
                ],
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/centrifuge-download/5",
                "sbg:revision": 5,
                "sbg:modifiedOn": 1527589742,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1509721131,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 5,
                "sbg:content_hash": null
            },
            "label": "Centrifuge Download - taxonomy",
            "sbg:x": 39.05821228027344,
            "sbg:y": 63.3334846496582
        },
        {
            "id": "#Centrifuge_Download___refseq",
            "inputs": [
                {
                    "id": "#Centrifuge_Download___refseq.domain",
                    "source": [
                        "#domain"
                    ]
                },
                {
                    "id": "#Centrifuge_Download___refseq.refseq_category",
                    "source": "#refseq_category"
                },
                {
                    "id": "#Centrifuge_Download___refseq.taxids",
                    "source": "#taxids"
                },
                {
                    "id": "#Centrifuge_Download___refseq.database",
                    "default": "refseq"
                }
            ],
            "outputs": [
                {
                    "id": "#Centrifuge_Download___refseq.names"
                },
                {
                    "id": "#Centrifuge_Download___refseq.nodes"
                },
                {
                    "id": "#Centrifuge_Download___refseq.emvec"
                },
                {
                    "id": "#Centrifuge_Download___refseq.univec"
                },
                {
                    "id": "#Centrifuge_Download___refseq.seqid2taxid"
                },
                {
                    "id": "#Centrifuge_Download___refseq.ref_sequences"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/centrifuge-download/5",
                "label": "Centrifuge Download",
                "description": "**Centrifuge Download** is part of the Centrifuge suite, used for downloading reference sequences from NCBI, prior to index building. It can be used as a standalone tool, or as part of the **Reference Index Creation** workflow.\n\n\n**Centrifuge** is a novel microbial classification engine that enables rapid, accurate, and sensitive labeling of reads and quantification of species present in metagenomic samples. The system uses a novel indexing scheme based on the Burrows-Wheeler transform (BWT) and the Ferragina-Manzini (FM) index, optimized specifically for the metagenomic classification problem.\n\n\n**Centrifuge Download**  does not take any file inputs. Instead, it has several input parameters (see *Ports* section) that define how and what will be downloaded.The most important parameters are as follows:\n\n* **Domain to download** (`--domain`) - a list of domains that sequences can be downloaded with;\n* **Taxonomy IDs** (`-t`) - a list of taxonomy identifiers for sequences that the user wants to download;\n* **Assembly level** (`-a`) and **Refseq category** (`-c`) - used for filtering the database from which the sequences will be downloaded;\n* **Database to use** - one of four types of databases: \"*taxonomy*\", \"*refseq*\", \"*genbank*\" or \"*contaminants*\".\n\nThe output of the tool depends on the database used:\n\n- **taxonomy** - it takes taxonomy dump from NCBI and creates *nodes.dmp* and *names.dmp* files;\n- **refseq** - downloads a list of arbitrary sequences from NCBI RefSeq. The output is a file with all downloaded sequences;\n- **genbank** - downloads a list of arbitrary sequences from NCBI GenBank. The output is a file  with all downloaded sequences;\n- **contaminants** - gets contaminant sequences from UniVec and EmVec. The outputs are *UniVec.fna* and *EmVec.fna* files.\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Centrifuge Download** is commonly used prior to **Centrifuge Build**, in order to download the sequences from NCBI databases, that will be used for making the index. Regardless of the type of sequences, **Centrifuge Build** needs information about the taxonomy used in the databases. Therefore, it is common practice to first run **Centrifuge Download** with **Database to use** set to \"*taxonomy*\" in order to have accurate *nodes.dmp* and *names.dmp*. Afterwards, **Centrifuge Download** is commonly run with one of the remaining **Database to use** values.\n\n### Changes Introduced by Seven Bridges\n\n* Originally, **Centrifuge Download** produces a set of .FNA files with sequences (for example, if sequences are downloaded from several domains, there will be an output file per domain). However, on the Seven Bridges platform **Centrifuge Download** automatically merges all files into one output file with all sequences.\n\n### Common Issues and Important Notes\n\n* Although none of the parameters are required in general, some combination of parameter values requires that some other parameter is set. For example, if **Database to use** is \"*refseq*\" or \"*genbank*\", then **Domain to download** is required.\n\n### Performance Benchmarking\n\nBased on our experience, depending on the selected domain, it takes between 5 minutes and one hour to download reference sequences from NCBI. Downloading fungal reference sequences takes only 5 minutes (with the cost of $0.05 on instance c4.2xlarge), while viral and bacterial sequences require approximately 40 minutes and an hour (at the cost of $0.30 and $0.50, using the same c4.2xlarge instance), respectively.",
                "baseCommand": [
                    "centrifuge-download"
                ],
                "inputs": [
                    {
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-P",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Number of processes when downloading.",
                        "id": "#number_of_threads"
                    },
                    {
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Folder for downloading",
                        "description": "Folder to which the files are downloaded. If not set, the default name is *download*.",
                        "id": "#download_folder"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": {
                                    "type": "enum",
                                    "name": "domain",
                                    "symbols": [
                                        "bacteria",
                                        "viral",
                                        "archaea",
                                        "fungi",
                                        "protozoa",
                                        "invertebrate",
                                        "plant",
                                        "vertebrate_mammalian",
                                        "vertebrate_other"
                                    ]
                                }
                            }
                        ],
                        "label": "Domain to download",
                        "description": "What domain to download. One or more of bacteria, viral, archaea, fungi, protozoa, invertebrate, plant, vertebrate_mammalian, vertebrate_other.",
                        "id": "#domain"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-a",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-a",
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n\tif ($job.inputs.assembly_level){\n  \t\treturn \"\\\"\" + $self + \"\\\"\"\n    }\n}"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Assembly level",
                        "description": "Only download genomes with the specified assembly level. Default: 'Complete Genome'.",
                        "id": "#assembly_level"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-c",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-c",
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.refseq_category){\n  \treturn \"\\'\" + $self + \"\\'\"\n  }\n}"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Refseq category",
                        "description": "Only download genomes in the specified refseq category. Default: any.",
                        "id": "#refseq_category"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-t",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-t",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Taxonomy IDs",
                        "description": "Only download the specified taxonomy IDs, comma separated. Default: any.",
                        "id": "#taxids"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-r",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-r",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include RNA sequences",
                        "description": "Download RNA sequences, too.",
                        "id": "#rna_sequences"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-u",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-u",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Filter unplaced sequences",
                        "description": "Filter unplaced sequences.",
                        "id": "#filter_unplaced"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-m",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-m",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Mask low-complexity regions",
                        "description": "Mask low-complexity regions using dustmasker. Default: off.",
                        "id": "#mask_low"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-l",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-l",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Modify header",
                        "description": "Modify header to include taxonomy ID. Default: off.",
                        "id": "#modify_header"
                    },
                    {
                        "sbg:category": "Options for refseq or genbank",
                        "sbg:altPrefix": "-g",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-g",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Download GI map",
                        "description": "Download GI map.",
                        "id": "#download_GI_map"
                    },
                    {
                        "sbg:category": "Database",
                        "type": [
                            {
                                "type": "enum",
                                "symbols": [
                                    "refseq",
                                    "genbank",
                                    "contaminants",
                                    "taxonomy"
                                ],
                                "name": "database"
                            }
                        ],
                        "inputBinding": {
                            "position": 150,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Database to use",
                        "description": "One of refseq, genbank, contaminants or taxonomy. Use refseq or genbank for genomic sequences, contaminants gets contaminant sequences from UniVec and EmVec, taxonomy for taxonomy mappings.",
                        "id": "#database"
                    },
                    {
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Base name for naming the index",
                        "description": "Basename describing the index; used for naming files.",
                        "id": "#basename"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Memory for a job on one CPU.",
                        "id": "#memory_per_job"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Taxonomy names",
                        "description": "Taxonomy names.",
                        "sbg:fileTypes": "DMP",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"names.dmp\"\n  \n}"
                            }
                        },
                        "id": "#names"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Taxonomy nodes",
                        "description": "Taxonomy nodes.",
                        "sbg:fileTypes": "DMP",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"nodes.dmp\"\n  \n}"
                            }
                        },
                        "id": "#nodes"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "EmVec contaminants",
                        "description": "EmVec contaminants.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"contaminants/EmVec.fna\"\n  \n}"
                            }
                        },
                        "id": "#emvec"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "UniVec contaminants",
                        "description": "UniVec contaminants.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n  if ($job.inputs.download_folder) {\n    folder = $job.inputs.download_folder + \"/\"\n  }\n  else {\n    folder = \"download/\"\n  }\n  \n  return folder + \"contaminants/UniVec.fna\"\n  \n}"
                            }
                        },
                        "id": "#univec"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "SeqID_to_TaxonomyID",
                        "description": "Sequence ID to taxonomy ID mapping.",
                        "sbg:fileTypes": "MAP",
                        "outputBinding": {
                            "glob": "*.map",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "class": "Expression",
                                    "engine": "#cwl-js-engine",
                                    "script": "{\n  if ($job.inputs.basename){\n    return $job.inputs.basename\n  }\n}"
                                }
                            }
                        },
                        "id": "#seqid2taxid"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Referent sequences",
                        "description": "Referent sequences.",
                        "sbg:fileTypes": "FNA",
                        "outputBinding": {
                            "glob": "*.fna",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "class": "Expression",
                                    "engine": "#cwl-js-engine",
                                    "script": "{\n  if ($job.inputs.basename){\n    return $job.inputs.basename\n  }\n}"
                                }
                            }
                        },
                        "id": "#ref_sequences"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if($job.inputs.number_of_threads){\n  \treturn $job.inputs.number_of_threads\n  }\n  return 1\n}"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.memory_per_job) {\n    return $job.inputs.memory_per_job\n  } else {\n    return 4096\n  }\n}"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/centrifuge:1.0.3_feb2018"
                    }
                ],
                "arguments": [
                    {
                        "position": 200,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.database == \"refseq\" || $job.inputs.database == \"genbank\"){\n    \n    if ($job.inputs.basename){\n      expand_command = \" > \"+ $job.inputs.basename + \".map\"\n    } else {\n      expand_command = \" > seqid2taxid.map\"\n    }\n    \n    if ($job.inputs.download_folder){\n      expand_command += \"; cat \"+ $job.inputs.download_folder+ \"/*/*.fna > \" \n    }\n    else {\n      expand_command += \"; cat download/*/*.fna > \"\n    }\n    \n    if ($job.inputs.basename){\n      expand_command += $job.inputs.basename + \".sequences.fna\"\n    }\n    else {\n      expand_command += \"input-sequences.fna\"\n    }\n    return expand_command\n  }\n}"
                        }
                    },
                    {
                        "position": 100,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n domains = \"\"\nif ($job.inputs.domain) {\n  for (i=0; i< $job.inputs.domain.length; i++){\n    domains += $job.inputs.domain[i] + \",\"\n  }\n  domains = \"-d \\\"\" + domains.substring(0,domains.length-1) +\"\\\"\"\n}\nreturn domains\n}"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "-o",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if ($job.inputs.download_folder){\n    return $job.inputs.download_folder\n  }\n  else {\n    return \"download\"\n  }\n}"
                        }
                    }
                ],
                "sbg:toolkitVersion": "1.0.3",
                "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/27",
                "sbg:job": {
                    "inputs": {
                        "download_folder": "",
                        "database": "refseq",
                        "rna_sequences": true,
                        "domain": [
                            "archaea",
                            "viral",
                            "fungi"
                        ],
                        "modify_header": true,
                        "mask_low": true,
                        "filter_unplaced": true,
                        "memory_per_job": 6,
                        "assembly_level": "",
                        "refseq_category": "",
                        "download_GI_map": true,
                        "number_of_threads": 5,
                        "taxids": "taxids-string-value",
                        "basename": "basename-string-value"
                    },
                    "allocatedResources": {
                        "cpu": 5,
                        "mem": 6
                    }
                },
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "https://ccb.jhu.edu/software/centrifuge/manual.shtml"
                    },
                    {
                        "label": "Source code",
                        "id": "https://github.com/infphilo/centrifuge"
                    }
                ],
                "sbg:cmdPreview": "centrifuge-download -o download  -d \"archaea,viral,fungi\"  refseq   > basename-string-value.map; cat download/*/*.fna > basename-string-value.sequences.fna",
                "sbg:projectName": "SBG Public data",
                "sbg:image_url": null,
                "sbg:categories": [
                    "Metagenomics"
                ],
                "sbg:toolAuthor": "John Hopkins University, Center for Computational Biology",
                "sbg:toolkit": "centrifuge",
                "sbg:publisher": "sbg",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/14"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/15"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/16"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/18"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1510650872,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/26"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1527589742,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-download/27"
                    }
                ],
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/centrifuge-download/5",
                "sbg:revision": 5,
                "sbg:modifiedOn": 1527589742,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1509721131,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 5,
                "sbg:content_hash": null
            },
            "label": "Centrifuge Download - refseq",
            "sbg:x": 34.67118453979492,
            "sbg:y": 269.8121337890625
        }
    ],
    "hints": [
        {
            "class": "sbg:AWSInstanceType",
            "value": "r4.4xlarge;ebs-gp2;1024"
        },
        {
            "class": "sbg:AlibabaCloudInstanceType",
            "value": "ecs.r5.4xlarge;cloud_ssd;1024"
        },
        {
            "class": "sbg:GoogleInstanceType",
            "value": "n1-highmem-16;pd-ssd;2000"
        }
    ],
    "requirements": [],
    "sbg:canvas_zoom": 0.5999999999999996,
    "sbg:canvas_y": 185,
    "sbg:expand_workflow": false,
    "sbg:image_url": null,
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1594797894,
            "sbg:revisionNotes": null
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1594805002,
            "sbg:revisionNotes": "Modified by mine"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1596457612,
            "sbg:revisionNotes": "Without fetch"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1596457618,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1598696534,
            "sbg:revisionNotes": "with all input as port"
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1598771097,
            "sbg:revisionNotes": "workflow with all parameter"
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1598771247,
            "sbg:revisionNotes": "renew"
        },
        {
            "sbg:revision": 7,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1603684011,
            "sbg:revisionNotes": "Pure Centrifuge only"
        },
        {
            "sbg:revision": 8,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1603684721,
            "sbg:revisionNotes": "Centrifuge with paired data tool"
        }
    ],
    "sbg:categories": [
        "Metagenomics"
    ],
    "sbg:projectName": "COVID19",
    "sbg:canvas_x": 230,
    "sbg:links": [
        {
            "id": "http://www.ccb.jhu.edu/software/centrifuge/manual.shtml",
            "label": "Centrifuge Manual"
        },
        {
            "id": "https://huttenhower.sph.harvard.edu/graphlan",
            "label": "Graphlan Home Page"
        }
    ],
    "sbg:appVersion": [
        "sbg:draft-2"
    ],
    "sbg:id": "hendrick.san/covid19/rapid-identification-workflow/8",
    "sbg:revision": 8,
    "sbg:revisionNotes": "Centrifuge with paired data tool",
    "sbg:modifiedOn": 1603684721,
    "sbg:modifiedBy": "hendrick.san",
    "sbg:createdOn": 1594797894,
    "sbg:createdBy": "hendrick.san",
    "sbg:project": "hendrick.san/covid19",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "hendrick.san"
    ],
    "sbg:latestRevision": 8,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a7fa2b276b4e35b1754496062340e5cde0247fa15deee4caf7dc7a999e1b9c9ec"
}
