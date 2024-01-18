SUBROUTINE TF.JBL.E.CNV.COMUDITY.DES
*-----------------------------------------------------------------------------
*Subroutine Type: To write Comudity Description by Comudity Code
*Attached To    : JBL.ENQ.JBL.ARV
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* 21/03/2021 -                            CREATE   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.HS.CODE.LIST
    
    $USING EB.Reports
    $USING EB.DataAccess
    
    FN.CMDT = 'F.BD.HS.CODE.LIST'
    F.CMDT= ''
    EB.DataAccess.Opf(FN.CMDT, F.CMDT)
    
    Y.COMDT.CD = EB.Reports.getOData()
    *EB.DataAccess.FRead(FN.CMDT.CD, Y.COMDT.CD, R.CMDT.CD, F.CMDT.CD, CMDT.ERR)
    EB.DataAccess.FRead(FN.CMDT, Y.COMDT.CD, R.CMDT.CD, F.CMDT, CMDT.ERR)
    IF R.CMDT.CD NE '' THEN
        Y.CMDT.DESC = R.CMDT.CD<HS.CO.DESCRIPTION>
        IF Y.CMDT.DESC NE '' THEN
            Y.CMDT.DESC.LIST = DCOUNT(Y.CMDT.DESC, @VM)
            FOR J = 1 TO Y.CMDT.DESC.LIST
                Y.CMDT.DESC1 = Y.CMDT.DESC<1,J>
                Y.CMDT.DES = Y.CMDT.DES : Y.CMDT.DESC1
            NEXT J
        END
    END
    EB.Reports.setOData(Y.CMDT.DES)
    
    
RETURN

END
