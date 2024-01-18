* @ValidationCode : Mjo4NTEwOTE5MjA6Q3AxMjUyOjE1NTMxNTc1NjQzNTM6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Mar 2019 14:39:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE BD.SCT.CAPTURE.ID
*-----------------------------------------------------------------------------
* Modification History :
* Edited By: Zubaed Hassan Shimanto
* Date: 03 December, 2020
*---------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.BD.L.SCT.CUS.SEQ.NO
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING ST.Customer
    $USING ST.CompanyCreation
    $USING EB.TransactionControl
    $USING EB.Logging
    
    IF EB.SystemTables.getVFunction() NE 'I'  THEN
        RETURN
    END

*To by pass existing record
    FN.BD.SCT.CAPTURE = 'F.BD.SCT.CAPTURE'
    F.BD.SCT.CAPTURE = ''

    EB.DataAccess.Opf(FN.BD.SCT.CAPTURE, F.BD.SCT.CAPTURE)
    Y.ID.NEW = EB.SystemTables.getIdNew()

*Y.OFS.SOURCE = EB.DataAccess.g
    EB.DataAccess.FRead(FN.BD.SCT.CAPTURE, EB.SystemTables.getComi(), REC.SCT.TEMP, F.BD.SCT.CAPTURE, ERR.SCT.TEMP)
    IF REC.SCT.TEMP NE '' THEN
        RETURN
    END
    
*To by pass unauthorized record
    FN.BD.SCT.CAPTURE.NAU = 'F.BD.SCT.CAPTURE$NAU'
    F.BD.SCT.CAPTURE.NAU = ''
    EB.DataAccess.Opf(FN.BD.SCT.CAPTURE.NAU, F.BD.SCT.CAPTURE.NAU)
    EB.DataAccess.FRead(FN.BD.SCT.CAPTURE.NAU, EB.SystemTables.getComi(), REC.SCT.NAU.TEMP, F.BD.SCT.CAPTURE.NAU, ERR.SCT.NAU.TEMP)
    IF REC.SCT.NAU.TEMP NE '' THEN
        RETURN
    END

*If record is already generated
    IF Y.RECORD.GENRATE EQ 'YES' THEN
        RETURN
    END
    
*By pass validation
    IF (OFS$OPERATION EQ 'VALIDATE' OR OFS$OPERATION EQ 'PROCESS') THEN
        RETURN
    END

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN


INIT:
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    FN.BD.L.SCT.CUS.SEQ.NO = 'F.BD.L.SCT.CUS.SEQ.NO'
    F.BD.L.SCT.CUS.SEQ.NO = ''

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    
    CUS.ID = EB.SystemTables.getComi()
    TEMP.CUS = EREPLACE(EB.SystemTables.getComi(),'SCT','')
RETURN
    
OPENFILES:
    EB.DataAccess.Opf(FN.BD.L.SCT.CUS.SEQ.NO,F.BD.L.SCT.CUS.SEQ.NO)
    EB.DataAccess.Opf(FN.COMPANY,F.COMPANY)
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
RETURN
    
PROCESS:
    EB.DataAccess.FRead(FN.CUSTOMER, CUS.ID, REC.CUS, F.CUSTOMER, CUS.ERR)
    IF REC.CUS NE '' THEN
        Y.SCT.CUS.SEQ.NO.ID = 'SCT' : CUS.ID
        EB.DataAccess.FRead(FN.BD.L.SCT.CUS.SEQ.NO, Y.SCT.CUS.SEQ.NO.ID, REC.SCT.SEQ, F.BD.L.SCT.CUS.SEQ.NO, ERR.SCT.SEQ)
    
        Y.TODAY = EB.SystemTables.getToday()
        ZEROS = '0000'
        Y.SEQNO = REC.SCT.SEQ<SCT.CUS.SEQ.NO> + 1
        Y.SEQNO.WITH.ZERO= ZEROS[1,LEN(ZEROS)-LEN(Y.SEQNO)]:Y.SEQNO
        Y.SCT.ID = Y.SCT.CUS.SEQ.NO.ID :'.':Y.TODAY[3,2]:'.':Y.SEQNO.WITH.ZERO
*        REC.SCT.SEQ<SCT.CUS.SEQ.NO>  = Y.SEQNO

*       WRITE REC.SCT.SEQ ON F.BD.L.SCT.CUS.SEQ.NO, Y.SCT.CUS.SEQ.NO.ID
*       EB.Logging.LogWrite(FN.BD.L.SCT.CUS.SEQ.NO, Y.SCT.CUS.SEQ.NO.ID, REC.SCT.SEQ, '')
*       EB.DataAccess.FWrite(F.BD.L.SCT.CUS.SEQ.NO,Y.SCT.CUS.SEQ.NO.ID,REC.SCT.SEQ)
*       EB.DataAccess.FWrite(FN.BD.L.SCT.CUS.SEQ.NO,Y.SCT.CUS.SEQ.NO.ID,Y.SEQNO)
*       EB.TransactionControl.JournalUpdate('')

        EB.SystemTables.setIdNew(Y.SCT.ID)
        Y.RECORD.GENRATE = 'YES'
    END
    ELSE
        EB.SystemTables.setE('CUSTOMER ': CUS.ID : ' ' : CUS.ERR)
    END

RETURN
           