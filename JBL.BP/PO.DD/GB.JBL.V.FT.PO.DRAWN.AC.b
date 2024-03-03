SUBROUTINE GB.JBL.V.FT.PO.DRAWN.AC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Subroutine Description:
* THIS ROUTINE FOR GET DEBIT FT ACCOUNT FOR PO FT ISSUE
* Attach To: VERSION(FUNDS.TRANSFER,MBL.PO.ISSUE)
* Attach As: VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 10/08/2020 -                             NEW   -NILOY SARKAR
*                                                 NITSL Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING ST.CompanyCreation
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc> </desc>
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    FN.COM = 'F.COMPANY'
    F.COM =''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.COM, F.COM)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc> </desc>
    Y.CATEG.AC=""
    Y.CATEG.AC = 'BDT152610001'
* Y.COM = EB.SystemTables.getIdCompany()
*Y.COMPANY=EB.SystemTables.getIdCompany()[6,4]
*EB.DataAccess.FRead(FN.COM, Y.COM, Rec.Com, F.COM, Y.ERR)
*Y.SUB.DEV.CODE = Rec.Com<ST.CompanyCreation.Company.EbComSubDivisionCode>
*IF Y.SUB.DEV.CODE NE '' THEN
*   EB.SystemTables.setComi(Y.CATEG.AC:Y.SUB.DEV.CODE)
*END
*ELSE
*EB.SystemTables.setComi(Y.CATEG.AC:Y.COMPANY)
	EB.SystemTables.setComi(Y.CATEG.AC)

*END
RETURN
*** </region>

END
