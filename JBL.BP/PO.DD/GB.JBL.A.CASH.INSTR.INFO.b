
SUBROUTINE GB.JBL.A.CASH.INSTR.INFO

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENT.INFO Template
* Attach To: VERSION(TELLER,JBL.PO.LCY.CASHIN)
* Attach As: AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.EB.JBL.INSTRUMENT.INFO
    
    $USING   FT.Contract
    $USING   TT.Contract
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.Foundation
    
    Y.FT.REC.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
    Y.TT.REC.STATUS = EB.SystemTables.getRNew(TT.Contract.Teller.TeRecordStatus)
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.INSTR.ID = EB.SystemTables.getIdNew()
    Y.APPLICATION = EB.SystemTables.getApplication()
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.INSTRUMENT.INFO = 'F.EB.JBL.INSTRUMENT.INFO'
    F.INSTRUMENT.INFO = ''

    EB.Foundation.MapLocalFields("TELLER", "LT.PUR.NAME", FLD.POS)
    Y.LT.PUR.NAME.POS = FLD.POS<1,1>
    Y.TOTAL.LT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    Y.LT.PUR.NAME = Y.TOTAL.LT<1, Y.LT.PUR.NAME.POS>
    
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.INSTRUMENT.INFO, F.INSTRUMENT.INFO)
RETURN

*-------
PROCESS:
*-------

    IF Y.APPLICATION EQ 'TELLER' THEN
        REC.INSTR.TYPE<EB.JBL37.INSTRUMENT.TYPE>= EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        REC.INSTR.TYPE<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalTwo)
* Purchaser -- LT.PUR.NAME
        REC.INSTR.TYPE<EB.JBL37.PURCHASER.NAME>= Y.LT.PUR.NAME
* PAYEE.NAME is Beneficiary
        REC.INSTR.TYPE<EB.JBL37.BENEFICIARY.NAME> = EB.SystemTables.getRNew(TT.Contract.Teller.TePayeeName)
        REC.INSTR.TYPE<EB.JBL37.ISSUED.BRANCH>= EB.SystemTables.getRNew(TT.Contract.Teller.TeCoCode)
        REC.INSTR.TYPE<EB.JBL37.STATUS>= "CASH DEPOSITED"
    END


    IF Y.APPLICATION EQ 'FUNDS.TRANSFER' THEN
        REC.INSTR.TYPE<EB.JBL37.INSTRUMENT.TYPE>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        REC.INSTR.TYPE<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        REC.INSTR.TYPE<EB.JBL37.ISSUED.BRANCH>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
        REC.INSTR.TYPE<EB.JBL37.STATUS>= "CASH DEPOSITED"
    END
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.INSTR.ID: ": Y.INSTR.ID :" REC.INSTR.TYPE: ": REC.INSTR.TYPE
    FileName = 'SHIBLI_INSTR.INFO.txt'
* FilePath = 'DL.BP'
    FilePath = 'D:\Temenos\t24home\default\SHIBLI.BP'
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
    
    WRITE REC.INSTR.TYPE TO F.INSTRUMENT.INFO, Y.INSTR.ID
    
RETURN
END

