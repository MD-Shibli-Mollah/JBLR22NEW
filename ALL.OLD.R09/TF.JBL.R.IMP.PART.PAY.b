SUBROUTINE TF.JBL.R.IMP.PART.PAY
*-----------------------------------------------------------------------------
*Subroutine Description: auto-populate dreawing info from JBL.IMP.PART.PAY.INFO application.
*Subroutine Type:
*Attached To    : DRAWINGS VERSION (DRAWINGS,JBL.IMPMAT.PPMT, DRAWINGS,JBL.IMPSP.PPMT)
*Attached As    : RECOURD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 1/10/2021 -                            CREATE   - Mahmudur Rahman(Udoy),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.IMP.PART.PAY.INFO
    
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
    FN.IMP.PART.PAY.INFO = "F.JBL.IMP.PART.PAY.INFO"
    F.IMP.PART.PAY.INFO = ""
    FN.DR = "F.DRAWINGS"
    F.DR = ""
    
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
    EB.DataAccess.Opf(FN.IMP.PART.PAY.INFO, F.IMP.PART.PAY.INFO)
*    EB.DataAccess.Opf(FN.DR, F.DR)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>

    Y.DRAW.ID = EB.SystemTables.getIdNew()
    Y.DRAW.REL.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    EB.DataAccess.FRead(FN.IMP.PART.PAY.INFO, Y.DRAW.ID, R.IMP.PART.PAY.INFO, F.IMP.PART.PAY.INFO, Y.JBL.IMP.ERR)
    IF R.IMP.PART.PAY.INFO THEN
        Y.FT.TXN.REF  = R.IMP.PART.PAY.INFO<JBL.IMP.FT.TXN.REF>
        Y.FT.TXN.DATE = R.IMP.PART.PAY.INFO<JBL.IMP.FT.TXN.DATE>
        Y.DOC.PAY.CCY = R.IMP.PART.PAY.INFO<JBL.IMP.DOC.PAY.CCY>
        Y.DOC.PAY.AMT = R.IMP.PART.PAY.INFO<JBL.IMP.DOC.PAY.AMT>
    
        Y.FT.COUNT = DCOUNT(Y.DOC.PAY.AMT, @VM)
        FOR I = 1 TO Y.FT.COUNT
            Y.TOT.ASSIN.AMT += Y.DOC.PAY.AMT<1,I>
        NEXT I
     
        CONVERT VM TO SM IN Y.FT.TXN.REF
        CONVERT VM TO SM IN Y.FT.TXN.DATE
        CONVERT VM TO SM IN Y.DOC.PAY.CCY
        CONVERT VM TO SM IN Y.DOC.PAY.AMT
    
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,LT.PART.FT.TXN.POS> = Y.FT.TXN.REF
        Y.TEMP<1,LT.PART.TXNDATE.POS> = Y.FT.TXN.DATE
        Y.TEMP<1,LT.PART.DOCRCCY.POS> = Y.DOC.PAY.CCY
        Y.TEMP<1,LT.PART.DOCRAMT.POS> = Y.DOC.PAY.AMT
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef,Y.TEMP)
    END
    Y.DR.CR.AMT = Y.DRAW.REL.AMT - Y.TOT.ASSIN.AMT
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAppDrawAmt, Y.DR.CR.AMT)
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrBenDrawAmt, Y.DR.CR.AMT)

RETURN
*** </region>


END
