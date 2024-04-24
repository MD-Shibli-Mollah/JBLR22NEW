
SUBROUTINE GB.ENQ.JBL.READ.FILE(Y.RETURN)
    
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.DIR = 'D:/Temenos/t24home/default/DL.BP'
* Y.DIR = 'SHIBLI.BP'
    Y.FILE.NAME = 'Bengali.txt'
    
    OPENSEQ Y.DIR, Y.FILE.NAME TO OUT.FILE ELSE
    END

    READSEQ Y.LINE FROM OUT.FILE THEN
        Y.DATA =TRIM(Y.LINE)

    END
    CLOSESEQ OUT.FILE
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = " My Data: ":Y.DATA
    FileName = 'SHIBLI.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************
    Y.RETURN<-1>= Y.DATA
END

