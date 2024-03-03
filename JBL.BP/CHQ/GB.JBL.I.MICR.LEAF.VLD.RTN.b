* @ValidationCode : MjotMTkyMzIwNzk0NDpDcDEyNTI6MTY2MDcxODk2OTcwNTpuYXppYjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Aug 2022 12:49:29
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
SUBROUTINE GB.JBL.I.MICR.LEAF.VLD.RTN
*
* Description : INPUT Leaf Category Wise
*
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
    $INSERT  I_F.CHEQUE.TYPE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.EB.JBL.MICR.MGT
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING CQ.ChqConfig
    $USING AC.AccountOpening

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*------
INIT:
*------
    FN.CHQ.TYPE='F.CHEQUE.TYPE'
    F.CHQ.TYPE=''

    FN.ACCT  = "F.ACCOUNT"
    F.ACCT   = ''

    FN.MICR = 'FBNK.EB.JBL.MICR.MGT'
    F.MICR = ''
*
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CHQ.TYPE, F.CHQ.TYPE)
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.MICR, F.MICR)
RETURN
*
*--------
PROCESS:
*--------

    IF EB.SystemTables.getVFunction() EQ "I" THEN

        Y.TR.TYPE = EB.SystemTables.getRNew(EB.JBL82.TR.TYPE)
        Y.CHQ.ISS = EB.SystemTables.getRNew(EB.JBL82.LEAF.TYPE)
        Y.T24.AC = EB.SystemTables.getRNew(EB.JBL82.ACCOUNT)
        Y.CHQ.TYPE = EB.SystemTables.getRNew(EB.JBL82.CHQ.TYPE)


*------------------------Leaf Number Validation----------------------------------*

        SEL.CMD = "SELECT ": FN.CHQ.TYPE :" WITH LT.TR.TYPE EQ ": Y.TR.TYPE
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

        EB.DataAccess.FRead(FN.CHQ.TYPE,SEL.LIST,REC.CHQ.REQ,F.CHQ.TYPE,ERR.REQ)
        EB.LocalReferences.GetLocRef('CHEQUE.TYPE','LT.LEAF.TYPE',Y.PRE.NO)

        Y.LEAF = REC.CHQ.REQ<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.PRE.NO>
        FIND Y.CHQ.ISS IN Y.LEAF SETTING Ap, Vp ELSE
            EB.SystemTables.setEtext("Invalid leaf number")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

*-------------Account Balance Checking Validation --------------*

        EB.DataAccess.FRead(FN.ACCT, Y.T24.AC, ACC.REC, F.ACCT, ERR)

        IF ACC.REC<AC.AccountOpening.Account.Category> NE '1111' AND ACC.REC<AC.AccountOpening.Account.Category> NE '1114' THEN

            Y.AC.BALANCE = ACC.REC<AC.AccountOpening.Account.WorkingBalance>
            Y.TOTAL.LEAF = Y.CHQ.ISS * EB.SystemTables.getRNew(EB.JBL82.NO.OF.BOOK)
            Y.LEAF.COST = Y.TOTAL.LEAF * 2.5
            Y.VAT = Y.LEAF.COST * 0.15
            Y.TOT.COST = Y.LEAF.COST + Y.VAT

            IF Y.AC.BALANCE LE 100 OR Y.AC.BALANCE LE Y.TOT.COST THEN
                EB.SystemTables.setEtext("Account Balance is not Sufficient")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
*-------------Duplicate Request Checking Validation --------------*
*        Y.MICR.PART.ID = Y.CHQ.TYPE:".":Y.T24.AC
*
*        SEL.CMD.MICR = "SELECT ": FN.MICR : " WITH @ID LIKE '":Y.MICR.PART.ID:"...'"
*        EB.DataAccess.Readlist(SEL.CMD.MICR,SEL.LIST.MICR,'',NO.OF.REC.MICR,RET.CODE.MICR)
*        EB.DataAccess.FRead(FN.MICR,SEL.LIST.MICR<NO.OF.REC.MICR>,REC.REQ,F.MICR,ERR.REQ.MICR)
*
*        IF REC.REQ NE '' THEN
*            EB.SystemTables.setEtext("Already given another request. Status is ":REC.REQ<EB.JBL82.STATUS>)
*            EB.ErrorProcessing.StoreEndError()
*        END
    END
RETURN
END
 