* @ValidationCode : MjotNDc4MTUwMDg5OkNwMTI1MjoxNjYwNjQ4ODM1ODU3Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:20:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.E.CNV.CHQ.ROUTING.NO
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.EB.BD.BANK.ROUTING.LIST

    $USING EB.DataAccess
    $USING EB.Reports
    FN.BR='FBNK.EB.BD.BANK.ROUTING.LIST'
    F.BR=''

    EB.DataAccess.Opf(FN.BR,F.BR)

    SEL.CMD="SELECT ":FN.BR:" WITH @ID LIKE 135... AND BRANCH.CODE EQ ":EB.Reports.getOData()
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
    EB.Reports.setOData(Y.REC.ID)

RETURN

END
