****************************************************
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
* PROGRAM    : Generate Source Tax deduct report
* DEV BY      : MD. IMRAN HASAN
* DEV DATE    : 2015-11-29
* UPDATE DATE : 2016-12-26
* REQ         : ICTD
* Tools *******
!TSM SERVICE - BNK/OFS.MESSAGE.SERVICE
!TSM SERVICE - BNK/OFS.RESPONSE.QUEUE
!ENQUIRY.REPORT,DEDUCT.INT.ST I ER.DEDUCT.INT.ST
****************************************************

    PROGRAM R.ICTD.RG.DEDUCT.INT.ST
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE


    Y.FILE.DIR = 'JBL.BP/REPGEN'
    Y.FILE.NAME = 'PARAMETER.ST.txt'
    Y.FILE = Y.FILE.DIR :'/': Y.FILE.NAME

    Y.YESCOUNT = 0
    OPENSEQ Y.FILE TO F.FILE.POINT THEN
        LOOP
            READSEQ Y.RECORD FROM F.FILE.POINT ELSE
                Y.RECORD = ''
            END
        WHILE Y.RECORD
            Y.REC<-1> = Y.RECORD
        REPEAT
    END

    FOR K = 1 TO DCOUNT(Y.REC,@FM)
        L.VALUES = FIELD(Y.REC,@FM,K)
        COMP.ID = FIELD(L.VALUES,',',1)
        Y.CATEG.ID = FIELD(L.VALUES,',',2)
        Y.PERCENT = FIELD(L.VALUES,',',3)

        IF Y.PERCENT EQ "15" THEN
            Y.V.MESSAGE = "ENQUIRY.REPORT,DEDUCT.INT.ST/V/PROCESS,//":COMP.ID:",ER.DEDUCT.INT.ST.":Y.CATEG.ID:".":Y.PERCENT
        END
        ELSE
            Y.V.MESSAGE = "ENQUIRY.REPORT,DEDUCT.INT.ST/V/PROCESS,//":COMP.ID:",ER.DEDUCT.INT.ST.":Y.CATEG.ID
        END
        V.MSG.ID = ''
        CALL OFS.POST.MESSAGE(Y.V.MESSAGE, V.MSG.ID ,"DM.OFS.SRC.VAL", "DMUSER")
        CALL JOURNAL.UPDATE ('TEST')

    NEXT K

    RETURN
END
