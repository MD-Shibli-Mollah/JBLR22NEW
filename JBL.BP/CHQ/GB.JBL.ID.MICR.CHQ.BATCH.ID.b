* @ValidationCode : MjoxMzgyNzAyNTU6Q3AxMjUyOjE2NjA3MjY0MTk3NTU6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Aug 2022 14:53:39
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
SUBROUTINE GB.JBL.ID.MICR.CHQ.BATCH.ID
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
*    SUBROUTINE JBL.MICR.CHQ.BATCH.ID OLD NAME
    !    PROGRAM JBL.MICR.CHQ.BATCH.ID
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INCLUDE  I_F.JBL.MICR.CHQ.BATCH
    $USING EB.SystemTables

    IF EB.SystemTables.getVFunction() EQ "I" THEN
        Y.ID = EB.SystemTables.getComi()
        Y.8N= FIELD(Y.ID,'.',2)
        Y.6N= FIELD(Y.ID,'.',3)
        !IF (EB.SystemTables.getComi() MATCHES "MICR'.'8N'.'6N") THEN
        IF (LEN(Y.8N) EQ 8 AND LEN(Y.6N) EQ 6) THEN
            EB.SystemTables.setComi(Y.ID)
        END
        ELSE

            !DATE.STAMP = OCONV(DATE(), 'D4-')
            Y.DATE.STAMP = EB.SystemTables.getToday()
            Y.TIME.STAMP = TIMEDATE()
            !Y.TIME.STAMP = EB.SystemTables.getTimeStamp()
            Y.DATE.TIME  ="MICR.":Y.DATE.STAMP:".": Y.TIME.STAMP[1,2]:Y.TIME.STAMP[4,2]:Y.TIME.STAMP[7,2]
            EB.SystemTables.setComi(Y.DATE.TIME)
        END
        RETURN
    END
