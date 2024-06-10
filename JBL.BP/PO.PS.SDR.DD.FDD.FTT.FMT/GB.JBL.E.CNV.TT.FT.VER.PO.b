
SUBROUTINE GB.JBL.E.CNV.TT.FT.VER.PO
*
*Developed By:
*    Date         : 10/06/2024
*    Developed By : MD Shibli Mollah
*    Designation  : Technical Analyst
*    Email        : shibli@nazihargroup.com
*    Attached To  : ENQUIRY - JBL.ENQ.INSTR.INFO.DETAILS
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Reports
    
    Y.ID = EB.Reports.getOData()
    Y.ID.LEN = Y.ID[1,2]
    
    IF Y.ID.LEN EQ 'FT' THEN
        Y.VER = "FUNDS.TRANSFER,JBL.INSTR.ISSUE"
    END
    
    ELSE
        Y.VER = "TELLER,JBL.INSTR.LCY.CASHIN"
    END
    EB.Reports.setOData(Y.VER)

RETURN
END

