#include "mex.h"

#include <fstream>

using namespace std;

template< class TypeLabel, class TypeData >
void svmwrite( const char* filename, void* ilabel, void* idata, int ndata, int ndim, char access)
{
	
	ofstream file;

	if ( access == 'a')
	{
		file.open(filename,ios::app);
	}
	else
	{
		file.open(filename);
	}
	
	TypeLabel* label = (TypeLabel*) ilabel;
	TypeData* data = (TypeData*) idata;
	
	for( int i=0;i<ndata;i++)
	{
		file << (int) (*(label++));
		
		for( int j=0;j<ndim;j++)
		{
			if ( ((*data) > 1e-10) || ((*data) < -1e-10))
			{
				file << "\t" << j+1 << ":" << (double) (*(data++));
			}
			else
			{
				data++;
			}
		}
		
		file << endl;
	}
	
	file.close();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
	if ( nrhs == 4)
	{
		char filename[256];
		mxGetString(prhs[0], filename, mxGetN(prhs[0])+1);				
		char access[256];
		mxGetString(prhs[3],access,mxGetN(prhs[3])+1);
	
		void* pLabel = mxGetPr(prhs[1]);
		void* pData = mxGetPr(prhs[2]);
		
		if ( mxGetM(prhs[1]) != mxGetN(prhs[2]))
		{
			mexErrMsgTxt("label data size not match.\n");
			return;
		}
		
		int ndata = mxGetN(prhs[2]);
		int ndim = mxGetM(prhs[2]);
		
		mxClassID classData = mxGetClassID(prhs[2]);
		mxClassID classLabel = mxGetClassID(prhs[1]);
		
		if ( (classData == mxDOUBLE_CLASS) && (classLabel == mxDOUBLE_CLASS))
		{
			svmwrite<double,double>(filename, pLabel,pData, ndata, ndim,access[0]);
		}
		else if ((classData == mxSINGLE_CLASS) && (classLabel == mxDOUBLE_CLASS))
		{
			svmwrite<double,float>(filename,pLabel,pData,ndata,ndim,access[0]);
		}
		else
		{
			mexErrMsgTxt("type not supported");
			return;
		}
	}
	else
	{
		mexErrMsgTxt("num of input should be four");
		return;
	}
} 
