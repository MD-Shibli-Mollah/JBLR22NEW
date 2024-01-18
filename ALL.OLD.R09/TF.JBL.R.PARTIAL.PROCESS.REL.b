SUBROUTINE TF.JBL.R.PARTIAL.PROCESS.REL
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : DRAWINGS VERSION (DRAWINGS,JBL.F.PPMT.EXPDOCREAL)
*Attached As    : RECOURD ROUTINE
*-----------------------------------------------------------------------------
* Modification History : auto-populate dreawing info from JBL.IMP.PART.PAY.INFO application.
* 01/10/2021 -                            CREATE   - Mahmudur Rahman(Udoy),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.EXP.PART.PAY.INFO
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LC.Contract
    $USING EB.Updates
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.EXP.PART.PAY.INFO = "F.JBL.EXP.PART.PAY.INFO"
    F.EXP.PART.PAY.INFO = ""
    
    FLD.POS = ''
    APPLICATION.NAMES = 'DRAWINGS'
    LOCAL.FIELDS = 'LT.PART.FT.TXN':VM:'LT.PART.TXNDATE':VM:'LT.PART.DOCRCCY':VM:'LT.PART.DOCRAMT'
    
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    LT.PART.FT.TXN.POS       = FLD.POS<1,1>
    LT.PART.TXNDATE.POS      = FLD.POS<1,2>
    LT.PART.DOCRCCY.POS      = FLD.POS<1,3>
    LT.PART.DOCRAMT.POS      = FLD.POS<1,4>
    
    Y.TOT.ASSIN.AMT = 0
    Y.DRAW.REL.AMT = 0
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.EXP.PART.PAY.INFO, F.EXP.PART.PAY.INFO)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>

    Y.DRAW.ID = EB.SystemTables.getIdNew()
    Y.DRAW.REL.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    EB.DataAccess.FRead(FN.EXP.PART.PAY.INFO, Y.DRAW.ID, R.EXP.PART.PAY.INFO, F.EXP.PART.PAY.INFO, Y.JBL.EXP.ERR)
    IF R.EXP.PART.PAY.INFO THEN
        Y.FT.TXN.REF  = R.EXP.PART.PAY.INFO<JBL.EXP.FT.TXN.REF>
        Y.FT.TXN.DATE = R.EXP.PART.PAY.INFO<JBL.EXP.FT.TXN.DATE>
        Y.DOC.RECV.CCY = R.EXP.PART.PAY.INFO<JBL.EXP.DOC.RECV.CCY>
        Y.DOC.RECV.AMT = R.EXP.PART.PAY.INFO<JBL.EXP.DOC.RECV.AMT>
    
        Y.FT.COUNT = DCOUNT(Y.DOC.RECV.AMT, @VM)
        FOR I = 1 TO Y.FT.COUNT
            Y.TOT.ASSIN.AMT += Y.DOC.RECV.AMT<1,I>
        NEXT I
    
        CONVERT VM TO SM IN Y.FT.TXN.REF
        CONVERT VM TO SM IN Y.FT.TXN.DATE
        CONVERT VM TO SM IN Y.DOC.RECV.CCY
        CONVERT VM TO SM IN Y.DOC.RECV.AMT
    
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,LT.PART.FT.TXN.POS> = Y.FT.TXN.REF
        Y.TEMP<1,LT.PART.TXNDATE.POS> = Y.FT.TXN.DATE
        Y.TEMP<1,LT.PART.DOCRCCY.POS> = Y.DOC.RECV.CCY
        Y.TEMP<1,LT.PART.DOCRAMT.POS> = Y.DOC.RECV.AMT
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef,Y.TEMP)
    END
    Y.DR.CR.AMT = Y.DRAW.REL.AMT - Y.TOT.ASSIN.AMT
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAppDrawAmt, Y.DR.CR.AMT)
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrBenDrawAmt, Y.DR.CR.AMT)

RETURN
*** </region>


****************************
*FILE.WRITE:
*    Y.LOG.FILE='EXPFile.txt'
*    Y.FILE.DIR ='./DFE.TEST'
*    OPENSEQ Y.FILE.DIR,Y.LOG.FILE TO F.FILE.DIR ELSE NULL
*    WRITESEQ WRITE.FILE.VAR APPEND TO F.FILE.DIR ELSE NULL
*    CLOSESEQ F.FILE.DIR
*RETURN


END
