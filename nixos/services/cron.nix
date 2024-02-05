{

    services.cron = {

      enable = true;
      systemCronJobs = [

      "*/5 * * * *      root    date >> /tmp/cron.log"
      "0 * * * * /path/to/notmuch new"

    ];
  };


}
