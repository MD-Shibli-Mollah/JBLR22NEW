
SUBROUTINE GB.JBL.E.CNV.TT.FT
*
*Developed By:
*    Date         : 09/06/2024
*    Developed By : MD Shibli Mollah
*    Designation  : Technical Analyst
*    Email        : shibli@nazihargroup.com
*    Attached To  : ENQUIRY - JBL.ENQ.INSTR.INFO.DETAILS , JBL.ENQ.INSTR.INFO.FOREIGN.DETAILS
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Reports
    
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""

    FN.TT = "F.TELLER"
    F.TT = ""

    Y.ID = EB.Reports.getOData()
    Y.ID.LEN = Y.ID[1,2]
    
    IF Y.ID.LEN EQ 'FT' THEN
        EB.DataAccess.Opf(FN.FT, F.FT)
        EB.DataAccess.FRead(FN.FT, Y.ID, REC.FT, F.FT, ERR.FT)
        Y.CREDIT.ACC.NO = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
    END
    
    ELSE
        EB.DataAccess.Opf(FN.TT, F.TT)
        EB.DataAccess.FRead(FN.TT, Y.ID, REC.TT, F.TT, ERR.TT)
        Y.CREDIT.ACC.NO = REC.TT<TT.Contract.Teller.TeAccountTwo>
    END

    Y.DEBIT.ACC.NO = Y.CREDIT.ACC.NO
    EB.Reports.setOData(Y.DEBIT.ACC.NO)

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = Y.ID:" Y.DEBIT.ACC.NO: ": Y.DEBIT.ACC.NO
    FileName = 'SHIBLI_FT.TT.txt'
* FilePath = 'DL.BP'
    FilePath = 'DL.BP'
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
  


RETURN
END

