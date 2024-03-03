SUBROUTINE GB.JBL.V.TT.DD.DRAW.AC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING ST.CompanyCreation
    $USING EB.Updates
    $USING TT.Contract
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
    FN.TELLER='F.TELLER'
    F.TELLER = ''
    
    Y.APP.NAME ="FUNDS.TRANSFER":FM:"TELLER"
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = "LT.COMPANY":FM:"LT.COMPANY"
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME, LOCAL.FIELDS,FLD.POS)
    Y.LT.COMPANY.POS = FLD.POS<1,1>
    Y.TT.COMPANY.POS = FLD.POS<2,1>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.COM, F.COM)
    EB.DataAccess.Opf(FN.TELLER, F.TELLER)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc> </desc>
    
    Y.CATEG.AC=""
    Y.CATEG.AC = 'BDT140460001'
    *Y.TT.LOC.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
*----get value from DD issue version Dropdawn -------*
    *Y.TT.PAYEE.COM = Y.TT.LOC.REF<1,Y.TT.COMPANY.POS>
    *Y.TT.COM = RIGHT(Y.TT.PAYEE.COM,4)
    ! if any company have sub devision code then it will take the sub devision code!
    *EB.DataAccess.FRead(FN.COM, Y.TT.PAYEE.COM, Rec.Com, F.COM, Y.ERR)
    *Y.SUB.DEV.CODE = Rec.Com<ST.CompanyCreation.Company.EbComSubDivisionCode>
    *IF Y.SUB.DEV.CODE NE '' THEN
     *   EB.SystemTables.setComi(Y.CATEG.AC:Y.SUB.DEV.CODE)
    *END
    *ELSE
     *   EB.SystemTables.setComi(Y.CATEG.AC:Y.TT.COM)
       EB.SystemTables.setComi(Y.CATEG.AC)
    *END
END
