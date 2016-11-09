#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

#define EOCD_MAGIC_NO 0x06054b50
#define CDFH_MAGIC_NO 0x02014b50
#define LFH_MAGIC_NO 0x04034b50


typedef struct {
uint32_t signiture;
uint16_t noDisk;
uint16_t diskCentralDir;
uint16_t noOfCDR;
uint16_t totalNoOfCDR;
uint32_t centralDirSize;
uint32_t centralDirOffset;
uint16_t commnetLen;
//char comment[];
}EOCD;


void printErr(char * s);
int readData(void* address, int size, FILE* in);
int readDatai(void* address, int size, int count, FILE* in);
void readDatav(void* address, int size, FILE* in);
void findEOCD(FILE* in, EOCD* eocd);
void readCDFHs(FILE* in, EOCD* eocd);
void dumpData(FILE* in, long headerOffset);

int main(int argc, char** argv) {


	if(argc != 2){
		printErr("Usage: zipParser zipFileName\n");
	}

	FILE* in;
	in = fopen(argv[1], "rb"); // I don`t check if something is fishy when opening the file because I don`t care...
	if(!in){
		printErr("Can not open zip file!");
	}

	EOCD eocd;
	findEOCD(in, &eocd);
	readCDFHs(in, &eocd);
	fclose(in);

	return EXIT_SUCCESS;
}

void printErr(char * s){
	fprintf(stderr, "%s", s);
	exit(1);
}

void readDatav(void* address, int size, FILE* in){
	int res = readData(address, size, in);
	if(res != 1){
        if(feof(in)){
            printErr("Reading has failed because it reached EOF!\n");
        }else{
            perror("Error when reading");
            printErr("Reading has failed\n");
        }
	}
}

int readData(void* address, int size, FILE* in){
	return readDatai(address, size, 1, in);
}

int readDatai(void* address, int size, int count, FILE* in){
	return fread(address, size, count, in);
}

void findEOCD(FILE* in, EOCD* eocd){
	fseek(in, -21, SEEK_END); //22 - 1
	uint32_t sig = 0;
	int found = 0;
	long EOCDPos = 0;

	while(!found){
		while(sig != EOCD_MAGIC_NO){
			long ret = fseek(in, -1, SEEK_CUR);
			if(ret == -1){
				printErr("Error in fseek!");
			}
			readDatav(&sig, 4, in);
			ret = fseek(in, -4, SEEK_CUR);// repositon
			if(ret == -1){
				printErr("Error in fseek!");
			}
		}


		if(sig != EOCD_MAGIC_NO){
			printErr("Something went wrong when reading EOCD!");
		}

		//found something like the signiture!
		EOCDPos = ftell(in);
		if(EOCDPos == -1){
			printErr("Error in ftell!");
		}

		uint32_t offset;
        uint32_t cdfh_sig;
		fseek(in, 16, SEEK_CUR); //offset
		readDatav(&offset, 4, in);
		fseek(in, offset, SEEK_SET); //sig
		readDatav(&cdfh_sig, 4, in);
		if(cdfh_sig == CDFH_MAGIC_NO){
			found = 1;
		}
	}

	eocd->signiture = sig;
	fseek(in, EOCDPos +10, SEEK_SET);
	readDatav(&(eocd->totalNoOfCDR), 2, in);
	readDatav(&(eocd->centralDirSize), 4, in);
	readDatav(&(eocd->centralDirOffset), 4, in);

}

void readCDFHs(FILE* in, EOCD* eocd){

	uint32_t firstOffset = eocd->centralDirOffset;
	uint32_t thisOffset = firstOffset;
	int i;
	for(i=0; i<(eocd->totalNoOfCDR); ++i){

		uint32_t cdfh_sig;
			fseek(in, thisOffset, SEEK_SET);
			readDatav(&cdfh_sig, 4, in);
			if(cdfh_sig != CDFH_MAGIC_NO){
				//printErr("Error for CDFH sign!\n");
				printErr("Corrupted ZIP file!\n");
			}

			//read the name len
			uint16_t s_len;
			uint16_t extra_len;
			uint16_t comment_len;
			uint32_t header_off;
			fseek(in, 24, SEEK_CUR);
			readDatav(&s_len, 2, in);
			readDatav(&extra_len, 2, in);
			readDatav(&comment_len, 2, in);
			fseek(in, 8, SEEK_CUR);
			readDatav(&header_off, 4, in);

			dumpData(in, header_off); //this destroys my file pos!!!!!

            /*//allready printed by dumpData()
			char* name = calloc(s_len+1, sizeof(char));
			if(name == NULL){
				printErr("Error allocating memory for name!\n");
			}
			//read the name
			fseek(in, thisOffset+46, SEEK_SET);
			readDatav(name, s_len, in);
			printf("Name = %s\n", name);
			free(name);
            */

			thisOffset+= 46 + s_len + extra_len + comment_len; //advance to next CDFH
	}

}


void dumpData(FILE* in, long headerOffset){
	uint32_t sig;
	uint16_t compresMet;
	uint32_t compressedSize;
	uint32_t uncompressedSize;
	uint16_t name_len;
	uint16_t extra_len;

	fseek(in, headerOffset, SEEK_SET);
	readDatav(&sig, 4, in);

	if(sig != LFH_MAGIC_NO){
		fprintf(stderr, "LOCAL FILE HEADER signature error!\n");
		return;
	}

	fseek(in, 4, SEEK_CUR);
	readDatav(&compresMet, 2, in);

	if(compresMet != 0){
		fprintf(stderr,"File is compressed!\n");
		return;
	}

	fseek(in, 8, SEEK_CUR);
	readDatav(&compressedSize, 4, in);
	readDatav(&uncompressedSize, 4, in);

	if(compressedSize != uncompressedSize){
		fprintf(stderr,"File is probably compressed! (compressedSize and uncompressedSize sizes do not match)\n");
		return;
	}

	readDatav(&name_len, 2, in);
	readDatav(&extra_len, 2, in);
	char* name = malloc((name_len+1) * sizeof(char));
	readDatav(name, name_len, in);
	name[name_len] = '\0';
	printf("File name: %s\n", name);

	fseek(in, extra_len, SEEK_CUR);
	//start of data!

	int out_fd = open(name, O_WRONLY | O_CREAT | O_EXCL,
				 S_IRUSR | S_IRGRP | S_IROTH);

	if(out_fd == -1){

        switch(errno){
            case EISDIR: //is a directory!
                {
                    int status = mkdir(name, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
                    if(status != -1){
                        free(name);
                        return; // it has nothing to write anymore so return!
                    }
                }
            default:
                perror("The file could not be created!");
                free(name);
                return;
             break;
        }

	}


	FILE* out = fdopen(out_fd, "wb");
	if(out==NULL){
		fprintf(stderr, "The file with name %s was not created!\n", name);
		free(name);
		return;
	}

	uint8_t* data = malloc(uncompressedSize);
	if(data == NULL){
		fprintf(stderr, "Not enough memory for file %s !\n", name);
		free(name);
		return; // maybe for other files it will have so do not exit now...
	}

	int bytes = readDatai(data, 1, uncompressedSize, in);
	int rez = fwrite(data, 1, bytes, out);

	if(rez != uncompressedSize){
		perror("Not all data was read/written!");
	}

	fclose(out);

	free(data);
	free(name);
}

