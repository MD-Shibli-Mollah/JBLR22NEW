* @ValidationCode : MjotMTI1ODk0NjQ6Q3AxMjUyOjE2NjA2MjkyNjI1Mjk6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Aug 2022 11:54:22
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
SUBROUTINE GB.JBL.E.CNV.CHQ.LEAF.TYPE.MULTI.RTN
* Description : Return Multivalue Leaf Type in a column
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
*
    $USING EB.Reports

    Y.MV.FLD = EB.Reports.getOData()
    Y.COUNT = DCOUNT(Y.MV.FLD,@VM)
    EB.Reports.setOData(Y.MV.FLD<1,Y.COUNT>)


RETURN
END
