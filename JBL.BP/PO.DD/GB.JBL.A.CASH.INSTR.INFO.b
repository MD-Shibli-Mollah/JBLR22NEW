
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
    $USING   EB.Updates
    
    Y.FT.REC.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
    Y.TT.REC.STATUS = EB.SystemTables.getRNew(TT.Contract.Teller.TeRecordStatus)
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.INSTR.ID = EB.SystemTables.getIdNew()
    Y.APPLICATION = EB.SystemTables.getApplication()

    IF Y.VFUNCTION EQ 'R' OR Y.FT.REC.STATUS EQ 'RNAU' OR Y.TT.REC.STATUS EQ 'RNAU' THEN
        IF Y.VFUNCTION NE "A" THEN
            RETURN
        END
    END
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.INSTRUMENT.INFO = 'F.EB.JBL.INSTRUMENT.INFO'
    F.INSTRUMENT.INFO = ''

*    Y.APP.NAME='FUNDS.TRANSFER' : FM : 'TELLER'
*    Y.LOCAL.FIELDS='LT.SCROLL' : VM : 'LT.COMPANY': VM : 'LT.DD.TT.MT':FM: 'LT.SCROLL': VM : 'LT.COMPANY': VM : 'LT.DD.TT.MT'
*    EB.Updates.MultiGetLocRef(Y.APP.NAME, Y.LOCAL.FIELDS, Y.FIELDS.POS)
*
*    Y.SCROLL.POS.FT=Y.FIELDS.POS<1,1>
*    Y.COMP.POS.FT = Y.FIELDS.POS<1,2>
*    Y.TTMT.POS.FT = Y.FIELDS.POS<1,3>
*
*    Y.SCROLL.POS.TT=Y.FIELDS.POS<2,1>
*    Y.COMP.POS.TT = Y.FIELDS.POS<2,2>
*    Y.TTMT.POS.TT = Y.FIELDS.POS<2,3>
    
    
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

