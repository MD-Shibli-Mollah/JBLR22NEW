
SUBROUTINE GB.JBL.A.FT.INSTR.UPDATE

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENTS.INFO Template
* Attach To: VERSION(FUNDS.TRANSFER,JBL.PO.ISSUE.2)
* Attach As: AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.EB.JBL.INSTRUMENTS.INFO
    
    $USING   FT.Contract
    $USING   TT.Contract
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.Updates
    
    Y.FT.REC.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.INSTR.ID = EB.SystemTables.getIdNew()
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.INSTRUMENT.INFO = 'F.EB.JBL.INSTRUMENTS.INFO'
    F.INSTRUMENT.INFO = ''
     
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.INSTRUMENT.INFO, F.INSTRUMENT.INFO)
RETURN

*-------
PROCESS:
*-------
    REC.INSTR<EB.JBL37.PAYEE.BRANCH>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
    REC.INSTR<EB.JBL37.STATUS>= "LEAF ISSUED"
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.INSTR.ID: ": Y.INSTR.ID :" REC.INSTR: ": REC.INSTR
    FileName = 'SHIBLI_INSTR.INFO.FT.txt'
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
    
    WRITE REC.INSTR TO F.INSTRUMENT.INFO, Y.INSTR.ID
    
RETURN
END

